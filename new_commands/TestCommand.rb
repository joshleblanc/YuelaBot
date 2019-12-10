module NewCommands
  class TestCommand < NewCommand

      description "This is a test commmand"

      command test: one do
        p event.message.content
      end

      command blah: two do
        p two
      end
  end
end