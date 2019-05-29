module Lib
  class Pagination
    def initialize
      @index = 0
      @results = []
    end

    def on_fetch(&blk)
      @fetch = blk
    end

    def on_next(&blk)

    end

    def reset
      @index = 0
      @results = []
    end
  end
end