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

task :deploy do
  require 'net/scp'
  require 'net/ssh'

  host = "atlas.hostineer.com"
  tar = "yuelabot.tar.gz"

  p "Compressing folder..."
  `tar --exclude-vcs-ignores --exclude-vcs --exclude .env -czf ../#{tar} .`
  p "Done compressing folder"
  Net::SCP.upload!(
      host,
      ENV['DEPLOY_USER'],
      "../yuelabot.tar.gz",
      "yuelabot.tar.gz",
      ssh: { password: ENV['DEPLOY_PASS'] }
  )

  Net::SSH.start(host, ENV['DEPLOY_USER'], password: ENV['DEPLOY_PASS']) do |ssh|
    ssh.open_channel do |ch|
      ch.request_pty
      ch.send_channel_request "shell" do |c, success|
        if success
          c.send_data "mkdir -p ~/yuelabot\n"
          c.send_data "tar -C ~/yuelabot/ -zxf #{tar}\n"
          c.send_data "cd ~/yuelabot\n"
          c.send_data "rvm use 2.4.1\n"
          c.send_data "bundle install --deployment\n"
          c.send_data "rake db:migrate\n"
          c.send_data "god restart yuela\n"

          c.on_data do |_, data|
            $stdout.print data
          end

          c.on_extended_data do |_, type, data|
            $stderr.print data
          end

          c.on_close do
            p "Channel closed"
          end
        else
          p "Channel failed to open"
        end
        ch.send_data "exit\n"
        ch.on_close do
          p "Shell closed"
        end
      end
    end
    ssh.loop
  end
end


Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
end

task default: :test