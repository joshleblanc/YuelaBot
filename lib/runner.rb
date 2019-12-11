require_relative './definition'

class Runner
  class << self
    def run(commands)
      commands.each do |command|
        definition = Definition.all[command.name]
        definition.run(command) if command
      end
    end
  end
end