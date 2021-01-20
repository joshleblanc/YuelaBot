class UserCommand < ApplicationRecord

  def self.existing_command(name)
    existing_command = Commands.constants.find do |c|
      command = Commands.const_get(c)
      command.is_a?(Class) && [command.name, *command.attributes[:aliases]].include?(name.to_sym)
    end
    Commands.const_get(existing_command) if existing_command
  end

  def self.can_create?(name)
    blacklisted_commands = ['help']
    !existing_command(name) && !blacklisted_commands.include?(name)
  end

  def run_user_command(event, *args)
    test = args.join(' ')
    if input == '.*' || test.match(/#{input}/)
      response = test.gsub(/#{input}/, output)
      response.gsub! /:.+?:(?!\d+>)/ do |m|
        formatted_emoji = BOT.all_emoji.find {|e| e.name == m[1...-1]}
        if formatted_emoji
          formatted_emoji.mention
        else
          m
        end
      end
      response
    end
  end

  def run_alias_command(event, *args)
    command = UserCommand.existing_command(input)
    target_args = output.split.push(*args)
    inject_middleware(command).call(event, *target_args)
  end

  def run(event, *args)
    return if event.from_bot?

    if self.alias?
      run_alias_command(event, *args)
    else
      run_user_command(event, *args)
    end
  end
end
