# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "log/whenever.log"
set :environment, @environment

# Include .db because cron does not recognize system variable used to store pass for DB
job_type :my_runner, "cd :path && rake Otrs:update_statistics"

# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

# runs with bundle exec whenever -i
# sets  /var/spool/cron/crontabs/"user" 
# check set crons with crontab -l

every 1.day, :at => '2:15 am' do
  # debug_my_runner "RatioStatistic.update"
  my_runner
end