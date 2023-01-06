require 'rufus-scheduler'

s = Rufus::Scheduler.singleton

unless defined?(Rails::Console) || File.split($0).last == 'rake' || Rails.env != 'production'
  # only schedule when not running from the Ruby on Rails console
	# or from a rake task
	
	#s.cron '0 6 * * *' do
	s.cron '0 17-23 * * *' do
		## send nag emails
		Rails.logger.info "\n\n\n\n\nIN NAG EMAIL RUFUS JOB\n\n\n\n\n"
	  unapproved = User.unapproved_and_needs_reminder
	  if unapproved.count > 0 
	  	AdminMailer.send_account_nag_emails(unapproved).deliver
	  end
	end

	## TG - commented 1/23; recent release changed #notification_to_approver
	## so that it is sent immediately after account creation. This is redundant
	# s.cron '0 7 * * *' do
	# 	## send new user notifications
	# 	Rails.logger.info "\n\n\n\n\nIN NOTIFICATION TO APPROVER EMAIL RUFUS JOB\n\n\n\n\n"
	# 	new_users = User.needs_admin_notification
	# 	approvers_notified = []
	# 	new_users.each do |user|
	# 		user.regional_approvers.each do |approver|
	# 			unless approvers_notified.include?(approver.email)
	# 				AdminMailer.notification_to_approver(user, approver).deliver_now
	# 				approvers_notified.push(approver.email) # only send 1 email per approver
	# 			end
	# 		end
	#   end
	# end

end