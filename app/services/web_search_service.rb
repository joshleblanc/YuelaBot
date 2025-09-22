class WebSearchService
  def self.search(query, limit: 3)
    new.search(query, limit: limit)
  end

  def search(query, limit: 3)
    return [] unless ENV['GOOGLE'] && ENV['SEARCH_ID']
    return [] if query.blank?

    begin
      service = Google::Apis::CustomsearchV1::CustomSearchAPIService.new
      service.key = ENV['GOOGLE']
      
      response = service.list_cses(
        q: query,
        cx: ENV['SEARCH_ID'],
        num: [limit, 10].min # Google API max is 10
      )

      (response.items || []).first(limit).map do |item|
        {
          title: item.title&.strip,
          link: item.link,
          snippet: item.snippet&.strip&.gsub(/\s+/, ' ')
        }
      end
    rescue => e
      Rails.logger.error "Web search error: #{e.message}"
      []
    end
  end

  def format_results_for_context(results, query)
    return "" if results.empty?

    context = "Web search results for '#{query}':\n"
    results.each_with_index do |result, index|
      context << "#{index + 1}. #{result[:title]}\n"
      context << "   #{result[:snippet]}\n"
      context << "   URL: #{result[:link]}\n\n"
    end
    context
  end
end