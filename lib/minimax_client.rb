require 'anthropic'
require 'faraday'
require 'json'

class MinimaxClient
  class << self
    def client
      @client ||= Anthropic::Client.new(
        api_key: ENV.fetch('MINIMAX_API_KEY'),
        base_url: 'https://api.minimax.io/anthropic'
      )
    end

    def model
      ENV.fetch('MINIMAX_MODEL', 'MiniMax-M2.7-highspeed')
    end

    # Define available tools
    def tools
      @tools ||= [
        {
          name: "web_search",
          description: "Search the web and get structured search results. Use this to find up-to-date information on any topic.",
          input_schema: {
            type: "object",
            properties: {
              query: {
                type: "string",
                description: "The search query"
              },
              num_results: {
                type: "number",
                description: "Number of results to return (default: 5)",
                minimum: 1,
                maximum: 20
              }
            },
            required: ["query"]
          }
        },
        {
          name: "fetch_url",
          description: "Fetch and parse content from a URL. Extracts page title, main content, and discovered links. Use this to read articles, documentation, or get detailed information from a specific webpage.",
          input_schema: {
            type: "object",
            properties: {
              url: {
                type: "string",
                description: "The URL to fetch (must be a valid HTTP/HTTPS URL)"
              }
            },
            required: ["url"]
          }
        }
      ]
    end

    def chat(messages:, model: self.model, system:, max_tokens: 4096, tools: nil)
      # Use default tools if none provided
      tools_to_use = tools || self.tools

      puts "=== MiniMax Chat Debug ==="
      puts "Tools being used: #{tools_to_use.map { |t| t[:name] }.inspect}"
      puts "Messages count: #{messages.length}"

      response = client.messages.create(
        model: model,
        max_tokens: max_tokens,
        system: system,
        messages: messages,
        tools: tools_to_use
      )

      puts "Response content types: #{response.content.map(&:type).inspect}"
      puts "=========================="

      # Handle tool use requests from the model
      while response.content.any? { |block| block.type == :tool_use }
        # Build tool result messages
        tool_result_blocks = []

        response.content.each do |block|
          if block.type == :tool_use
            # Execute the tool
            result = execute_tool(block.name, block.input)
            tool_result_blocks << {
              type: "tool_result",
              tool_use_id: block.id,
              content: result
            }
          end
        end

        # Add assistant's tool_use message and user's tool_result message to conversation
        assistant_message = {
          role: 'assistant',
          content: response.content.select { |block| block.type == :tool_use }.map do |block|
            { type: 'tool_use', id: block.id, name: block.name, input: block.input }
          end
        }

        user_message_with_results = {
          role: 'user',
          content: tool_result_blocks
        }

        messages = messages + [assistant_message, user_message_with_results]

        response = client.messages.create(
          model: model,
          max_tokens: max_tokens,
          system: system,
          messages: messages,
          tools: tools_to_use
        )
      end

      # Extract text content from response
      text_parts = response.content.select { |block| block.type == :text }.map(&:text)

      if text_parts.any?
        text_parts.join("\n")
      else
        # If no text blocks, check for thinking content
        thinking_parts = response.content.select { |block| block.type == :thinking }.map(&:thinking)
        thinking_parts.join("\n") rescue ''
      end
    end

    def execute_tool(name, input)
      puts "=== Tool Execution Debug ==="
      puts "Tool: #{name}"
      puts "Input: #{input.inspect}"
      puts "==========================="

      case name
      when "web_search"
        search(input[:query], input[:num_results])
      when "fetch_url"
        fetch_url(input[:url])
      else
        "Unknown tool: #{name}"
      end
    end

    def search(query, num_results = 5)
      # Handle empty or nil query
      return "Error: No search query provided" if query.nil? || query.to_s.strip.empty?

      # Search requires a Coding Plan API key, not the regular API key
      api_key = ENV.fetch('MINIMAX_CODING_PLAN_API_KEY', ENV.fetch('MINIMAX_API_KEY'))

      puts "Search response query: #{query}"

      conn = Faraday.new(url: "https://api.minimax.io") do |f|
        f.response :json
      end

      response = conn.post do |req|
        req.path = "/v1/coding_plan/search"
        req.headers["Authorization"] = "Bearer #{api_key}"
        req.headers["Content-Type"] = "application/json"
        req.headers["MM-API-Source"] = "Minimax-MCP"
        req.body = { q: query }.to_json
      end

      begin
        result = response.body

        # Debug output
        puts "Search response status: #{response.status}"
        puts "Search response body: #{result.inspect}"

        p result

        if result["base_resp"] && result["base_resp"]["status_code"] != 0
          return "Search error: #{result['base_resp']['status_msg']}"
        end

        # Format results
        output = "## Web Search Results: \"#{query}\"\n\n"

        if result["organic"] && result["organic"].any?
          result["organic"].first(num_results).each do |r|
            output += "### #{r['title']}\n"
            output += "- **URL:** #{r['link']}\n"
            output += "- **Snippet:** #{r['snippet']}\n\n"
          end
        else
          output += "No results found.\n"
        end

        if result["related_searches"] && result["related_searches"].any?
          output += "## Related Searches\n\n"
          result["related_searches"].each do |rs|
            output += "- #{rs['query']}\n"
          end
        end

        output
      rescue => e
        p "Search failed #{e.message}"
        "Search failed: #{e.message}"
      end
    end

    def chat_with_web_search(message, model: self.model, system:)
      chat(
        messages: [
          { role: 'user', content: [{ type: 'text', text: message }] }
        ],
        model: model,
        system: system
      )
    end

    def fetch_url(url)
      # Validate URL
      return "Error: No URL provided" if url.nil? || url.to_s.strip.empty?

      uri = URI.parse(url)
      unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
        return "Error: Invalid URL. Must be a valid HTTP or HTTPS URL."
      end

      begin
        # Fetch the page using Faraday (already available in the project)
        conn = Faraday.new(url: url) do |f|
          f.options.timeout = 15
          f.options.open_timeout = 10
          f.adapter Faraday.default_adapter
        end

        response = conn.get

        if response.success?
          content_type = response.headers['content-type']

          # Only parse HTML content
          if content_type&.include?('text/html')
            parse_html_content(response.body, url)
          else
            "Fetched content is not HTML (#{content_type}). Content preview:\n\n#{response.body[0..1000]}"
          end
        else
          "Error: HTTP #{response.status} - #{response.reason_phrase}"
        end
      rescue Faraday::Error, SocketError, OpenSSL::SSL::SSLError => e
        "Error fetching URL: #{e.message}"
      rescue Timeout::Error
        "Error: Request timed out"
      end
    rescue URI::InvalidURIError
      "Error: Invalid URL format"
    end

    def parse_html_content(html, source_url)
      doc = Nokogiri::HTML(html)

      # Extract title
      title = doc.at_css('title')&.text&.strip || "No title found"

      # Extract meta description
      description = doc.at_css('meta[name="description"]')&.[]('content')&.strip

      # Extract main content - try common article/content selectors
      main_content = extract_main_content(doc)

      # Extract links (up to 10 relevant ones)
      links = extract_links(doc, source_url)

      # Build output
      output = "## #{title}\n\n"

      if description
        output += "**Description:** #{description}\n\n"
      end

      output += "**Source:** #{source_url}\n\n"

      if main_content && main_content.length > 100
        output += "### Content\n\n#{main_content[0..3000]}#{main_content.length > 3000 ? '...' : ''}\n\n"
      elsif main_content
        output += "### Content\n\n#{main_content}\n\n"
      end

      if links.any?
        output += "### Links Found\n\n"
        links.first(10).each do |link|
          output += "- #{link[:text]}: #{link[:url]}\n"
        end
        output += "\n"
      end

      output
    end

    def extract_main_content(doc)
      # Try to find main content using common selectors
      content_selectors = [
        'article',
        'main',
        '[role="main"]',
        '.post-content',
        '.article-content',
        '.entry-content',
        '.content',
        '#content',
        '.post',
        '.article'
      ]

      content_element = nil
      content_selectors.each do |selector|
        element = doc.at_css(selector)
        if element
          content_element = element
          break
        end
      end

      content_element ||= doc.at_css('body')

      return nil unless content_element

      # Remove script, style, nav, header, footer elements
      content_element.search('script, style, nav, header, footer, aside, .sidebar, .comments, .social-share, .advertisement, .ad, .related-posts').remove

      # Get text content and clean it up
      text = content_element.text
      text.gsub(/\s+/, ' ').strip
    end

    def extract_links(doc, source_url)
      base_uri = URI.parse(source_url)

      doc.css('a[href]').map do |link|
        href = link['href']
        next if href.nil? || href.empty?

        begin
          # Handle relative URLs
          resolved_url = base_uri.merge(href).to_s

          # Only include http/https links
          if resolved_url.start_with?('http')
            {
              text: link.text.strip[0..100],
              url: resolved_url
            }
          end
        rescue URI::Error
          nil
        end
      end.compact.uniq { |l| l[:url] }
    end
  end
end
