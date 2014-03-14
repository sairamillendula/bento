set :output, "#{path}/log/cron_log.log"

every 1.day, at: "11:30 PM" do
  #rake "scheduled_jobs:remove_old_carts"
  rake "scheduled_jobs:remove_old_carts"
  command "echo '**** whenever triggered ****'"
end

every 1.day, at: "11:59 PM" do
  #rake "scheduled_jobs:send_reminder_to_abandoned_carts"
  rake "scheduled_jobs:send_reminder_to_abandoned_carts"
  command "echo '**** whenever triggered ****'"
end

# every '0 2 20 * *' do ==> every month on the 20th at 2am
# *     *     *   *    *        command to be executed
# -     -     -   -    -
# |     |     |   |    |
# |     |     |   |    +----- day of week (0 - 6) (Sunday=0)
# |     |     |   +------- month (1 - 12)
# |     |     +--------- day of month (1 - 31)
# |     +----------- hour (0 - 23)
# +------------- min (0 - 59)

# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
#   command "echo 'you can use raw cron syntax too'; whenever --set environment=development;"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever