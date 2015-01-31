require 'rake'
require "sinatra/activerecord/rake"
require ::File.expand_path('../config/environment', __FILE__)


Rake::Task["db:create"].clear
Rake::Task["db:drop"].clear


desc "check time at 10min intervals"
task "check:time" do
  Event.check_time
end

desc "check vote count at 10min intervals"
task "check:votes" do
  Event.check_votes
end



# NOTE: Assumes SQLite3 DB
desc "create the database"
task "db:create" do
  touch 'db/db.sqlite3'
end

desc "drop the database"
task "db:drop" do
  rm_f 'db/db.sqlite3'
end

desc 'Retrieves the current schema version number'
task "db:version" do
  puts "Current version: #{ActiveRecord::Migrator.current_version}"
end