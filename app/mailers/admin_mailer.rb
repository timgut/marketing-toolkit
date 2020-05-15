class AdminMailer < ActionMailer::Base
  default from: 'do-not-reply@afscme.org'
  layout 'mailer'

   def new_user_waiting_for_approval(user)
    @user = user
    mail(to: @user.email, subject: 'Thanks for registering for the AFSCME Toolkit')
  end

  def notification_to_approvers(user, approvers)
    @user = user
    unless @user.approved
      if approvers.count > 0
        emails = approvers.pluck(:email)
      else
        region = @user.affiliate ? @user.affiliate.region.downcase : 'default'
        emails = MAIL_CONFIG['vetter'][region]
      end
      mail(to: emails, subject: "Toolkit account request from #{user.name}")
    end
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

  def send_account_nag_emails(unapproved_users)
    @unapproved = unapproved_users
    recipient = MAIL_CONFIG['nagger']
    mail(to: recipient, subject: "Toolkit account application(s) waiting for approval")
    unapproved_users.each do |user|
      user.approval_reminder_sent = DateTime.now
      # puts "\n\nSaving #{user.name} with a reminder value of #{DateTime.now.to_s}\n\n"
      user.save
    end
  end
end
