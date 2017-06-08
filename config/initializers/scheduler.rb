require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

unless defined?(Rails::Console) || File.split($0).last == 'rake'
  # only schedule when not running from the Ruby on Rails console
  # or from a rake task
	s.cron '0 6 * * *' do
	  ## send nag emails
	  unapproved = User.unapproved_and_needs_reminder
	  if unapproved.count > 0 
	  	AdminMailer.send_account_nag_emails(unapproved).deliver
	  end
	end

end