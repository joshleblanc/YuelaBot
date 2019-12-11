require 'yaml'

class Definition

  attr_accessor :description, :usage, :inputs, :entry

  def name
    if inputs.is_a? Array
      inputs[0]
    else
      str = inputs.keys.join(':')
      str += ":"
      str
    end
  end

  def run(command)
    contents = File.read("./commands/rb/#{@entry}")
    p = proc {
      test = 1
    }
    eval(contents, p.binding)
  end

  class << self
    def parse(str)
      result = YAML.load(str)
      definition = Definition.new
      definition.description = result["description"]
      definition.usage = result["usage"]
      definition.inputs = result["inputs"]
      definition.entry = result["entry"]
      @@definitions ||= {}
      @@definitions[definition.name] = definition
      definition
    end

    def all
      @@definitions
    end
  end
end