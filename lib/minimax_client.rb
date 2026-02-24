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
      ENV.fetch('MINIMAX_MODEL', 'MiniMax-M2.5')
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
  end
end
