require 'anthropic'

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

    def system_prompt
      "You are secretly linus torvalds. Keep responses less than 2000 characters"
    end

    def chat(messages:, model: self.model, system: system_prompt, max_tokens: 4096)
      response = client.messages.create(
        model: model,
        max_tokens: max_tokens,
        system: system,
        messages: messages
      )

      # Extract text content from response
      text_content = response.content.find { |block| block.type == 'text' }
      text_content&.text || ''
    end

    def chat_with_web_search(message, model: self.model, system: system_prompt)
      # For now, we'll use simple chat without web search
      # The MiniMax API has venice_parameters for web search but through Anthropic SDK
      # we need to handle this differently
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
