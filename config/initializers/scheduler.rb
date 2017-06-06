require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

##unless defined?(Rails::Console) || File.split($0).last == 'rake'

  # only schedule when not running from the Ruby on Rails console
  # or from a rake task

s.cron '* * * * *' do
  ## send nag emails
  puts "send account nag running..." 
  AdminMailer.send_account_nag_emails.deliver
end
 
##end