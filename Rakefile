require 'rake'
require "sinatra/activerecord/rake"
require ::File.expand_path('../config/environment', __FILE__)


# below rake tasks are run every 10 minutes via Heroku Scheduler
desc "check time at 10min intervals"
task "check:time" do
  Event.check_time
end

desc "check vote count at 10min intervals"
task "check:votes" do
  Event.check_votes
end


desc 'Retrieves the current schema version number'
task "db:version" do
  puts "Current version: #{ActiveRecord::Migrator.current_version}"
end