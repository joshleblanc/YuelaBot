module Apis
  module FourChan
    BASE_URL = "a.4cdn.org"

    def self.boards
      @boards ||= get("/boards")['boards']
    end

    def self.threads(board)
      get("/#{board}/threads.json")
    end

    def self.catalog(board)
      get("/#{board}/catalog.json")
    end

    def self.archive(board)
      get("/#{board}/archive.json")
    end

    def self.page(board, page)
      get("/#{board}/#{page + 1}.json")
    end

    def self.thread(board, thread)
      get("/#{board}/thread/#{thread}.json")
    end

    private
    def get(url)
      JSON.parse("#{BASE_URL}#{url}")
    end
  end
end