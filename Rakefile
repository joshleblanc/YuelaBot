require 'rake'
require 'active_record'

include ActiveRecord::Tasks
DatabaseTasks.database_configuration = YAML::load(File.open('./config/database.yml'))
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
  end

