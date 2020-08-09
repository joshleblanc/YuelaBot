require 'rake'
require 'erb'
require 'rake/testtask'
require 'active_record'
require 'dotenv/load'

include ActiveRecord::Tasks
DatabaseTasks.database_configuration = YAML.load(ERB.new(File.read('./config/database.yml')).result)
DatabaseTasks.root = "."
DatabaseTasks.db_dir = 'db'
DatabaseTasks.env = ENV['RACK_ENV'] || 'development'
DatabaseTasks.migrations_paths = ["./db/migrate"]

task :environment do
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
end

load 'active_record/railties/databases.rake'

namespace :g do
  desc "Generate migration"
  task :migration do
    name = ARGV[1] || raise("Specify name: rake g:migration your_migration")
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    path = File.expand_path("../db/migrate/#{timestamp}_#{name}.rb", __FILE__)
    migration_class = name.split("_").map(&:capitalize).join

    File.open(path, 'w') do |file|
      file.write <<-EOF
class #{migration_class} < ActiveRecord::Migration[5.2]
  def change
  end
end
      EOF
    end

    puts "Migration #{path} created"
    abort # needed stop other tasks
  end

  desc "Generate command"
  task :command do
    name = ARGV[1] || raise("Specify name: rake g:command your_command")
    path = File.expand_path("../commands/#{name}_command.rb", __FILE__)
    class_name = name.split("_").map(&:capitalize).join + "Command"
    File.open(path, 'w') do |file|
      file.write <<-EOF
module Commands
  class #{class_name}
    class << self
      def name
        :#{name}
      end

      def attributes
        {
          description: "TODO: Describe the command",
          usage: "TODO: How to use the command",
          aliases: []
        }
      end

      def command(event, *args)
        return if event.from_bot?
      end
    end
  end
end
      EOF
      puts "#{class_name} created: #{path}"
      abort
    end
  end

  desc "Generate middleware"
  task :middleware do
    name = ARGV[1] || raise("Specify name: rake g:middleware your_middleware")
    path = File.expand_path("../middleware/#{name}_middleware.rb", __FILE__)
    class_name = name.split("_").map(&:capitalize).join + "Middleware"
    File.open(path, 'w') do |file|
      file.write <<-EOF
module Middleware
  class #{class_name} < ApplicationMiddleware
    ###
    # The before and after method stubs are defined in ApplicationMiddleware
    # They can safely be deleted if you're not using that particular method.

    ###
    # Called before running the command. The output will be passed into the command
    # as the arguments
    def before(event, *args)
      args
    end

    ###
    # Called after running the command. The output will be used as the output of the command.
    # Note: If the command uses event.respond or any other methods of writing to discord, this value will
    # not be intercepted.
    def after(event, output, *args)
      output
    end
  end
end
      EOF
      puts "#{class_name} created: #{path}"
      abort
    end
  end
end

task :console do
  require 'require_all'
  require 'irb'
  require_relative 'models/application_record'
  require_all './models'
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
  ARGV.clear
  IRB.start
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
end

task default: :test