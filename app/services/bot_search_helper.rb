class BotSearchHelper
  def self.should_perform_web_search?(content)
    # Keywords that suggest the user wants current information or factual data
    search_indicators = [
      /what.*(?:is|are|was|were|will|does|do|did|can|could|should|would)/i,
      /how.*(?:to|do|does|did|can|could|should|would|much|many)/i,
      /when.*(?:is|was|will|did|does|do)/i,
      /where.*(?:is|are|was|were|can|could|should|would)/i,
      /who.*(?:is|are|was|were|will|does|do|did)/i,
      /why.*(?:is|are|was|were|will|does|do|did)/i,
      /(?:search|find|look up|google|tell me about|information about)/i,
      /(?:latest|recent|current|news|today|yesterday|this week|this month)/i,
      /(?:price|cost|value|worth) of/i,
      /(?:definition|meaning) of/i
    ]
    
    # Don't search for very short queries or personal/conversational content
    return false if content.length < 10
    return false if content.match?(/(?:hello|hi|hey|thanks|thank you|bye|goodbye)/i)
    return false if content.match?(/(?:how are you|what's up|what are you)/i)
    
    search_indicators.any? { |pattern| content.match?(pattern) }
  end

  def self.extract_search_query(content)
    # Remove common conversational elements and extract the core query
    query = content.dup
    
    # Remove question words at the beginning if they're followed by other content
    query = query.gsub(/^(?:what|how|when|where|who|why|can you|could you|please)\s+/i, '')
    
    # Remove common phrases
    query = query.gsub(/(?:tell me about|information about|search for|find|look up|google)\s+/i, '')
    
    # Clean up and return
    query.strip
  end
end