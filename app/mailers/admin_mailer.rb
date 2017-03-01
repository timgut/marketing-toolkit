class AdminMailer < ActionMailer::Base
  default from: 'chi-dev@trilogyinteractive.com'
  layout 'mailer'

   def new_user_waiting_for_approval(user)
    @user = user
    mail(to: @user.email, subject: 'Thanks for registering for the AFSCME Toolkit')
  end

  def notification_to_approvers(user, approvers)
  	@user = user
  	emails = approvers.pluck(:email)
  	mail(to: emails, subject: "Toolkit account request from #{user.name}")
  end

  def send_account_activation(user)
    @user = user    
    mail(to: @user.email, subject: "Your AFSCME Toolkit account is now active")
  end

  def send_account_rejection(user)
    @user = user
    mail(to: @user.email, subject: "Your AFSCME Toolkit account has been declined")
  end

  def send_account_suspension(user)
    @user = user
    mail(to: @user.email, subject: "Your AFSCME Toolkit account has been suspended")
  end

end
