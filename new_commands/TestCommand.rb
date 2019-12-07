module NewCommands
  class TestCommand < NewCommand
      command test: one do
          p one, event
      end
  end
end