require 'kovid'
require 'thor'

module Kovid
  class Cli < Thor
    def self.exit_on_failure?
      true
    end
  end
end