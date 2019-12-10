module NewCommands
  class TestCommand < NewCommand

      description "This is a test commmand"

      command test: one do
          p one, event
      end


  end
end