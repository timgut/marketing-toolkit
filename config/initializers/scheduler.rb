require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

unless defined?(Rails::Console) || File.split($0).last == 'rake' || Rails.env != 'production'
  # only schedule when not running from the Ruby on Rails console
  # or from a rake task
	s.cron '0 6 * * *' do
	  ## send nag emails
	  unapproved = User.unapproved_and_needs_reminder
	  if unapproved.count > 0 
	  	AdminMailer.send_account_nag_emails(unapproved).deliver
	  end
	end

	s.cron '0 7 * * *' do
	  ## send new user notifications
		new_users = User.needs_admin_notification
		approvers_notified = []
		new_users.each do |user|
			user.regional_approvers.each do |approver|
				unless approvers_notified.include?(approver.email)
					AdminMailer.notification_to_approver(user, approver).deliver_now
					approvers_notified.push(approver.email) # only send 1 email per approver
				end
			end
	  end
	end

end