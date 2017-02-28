class AdminMailer < ActionMailer::Base
  default from: 'chi-dev@trilogyinteractive.com'
  layout 'mailer'

   def new_user_waiting_for_approval(user)
    @user = user
    mail(to: @user.email, subject: 'Thanks for registering for the AFSCME Toolkit')
  end

  def notification_to_approvers(user, approvers)
  	@user = user
  	emails = approvers.select { |approver| approver.email }
  	mail(to: emails, subject: "Toolkit account request from #{user.name}")
end
