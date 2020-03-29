require 'kovid'
require 'thor'

module Kovid
  class CLI < Thor
    def self.exit_on_failure?
      true
    end
  end
end