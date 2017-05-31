class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :documents
  has_and_belongs_to_many :images

  belongs_to :affiliate

  scope :approved, -> { where(approved: 1) }
  scope :unapproved, -> { where(approved: 0, rejected: 0) }
  scope :rejected, -> { where(rejected: 1) }

  #scope :approvers, -> { where(role: ['Administrator','Vetter']) }
  scope :approvers, -> { where(role: 'Vetter') }

  after_create :send_admin_emails

  ROLES = ['User', 'Local President', 'Vetter', 'Administrator']
  DEPARTMENTS = ['IU-Communications', 'IU-Organizing', 'IU-Political', 'Council-Communications','Council-Organizing', 'Council-Political', 'Local-President']

  def send_admin_emails
    AdminMailer.new_user_waiting_for_approval(self).deliver_now
    unless self.admin?
      AdminMailer.notification_to_approvers(self, self.regional_approvers).deliver_now
    end
  end

  def send_account_notification(status)
    case status
    when 'approved'
        AdminMailer.send_account_activation(self).deliver_now
        self.send_reset_password_instructions
    when 'rejected'
        AdminMailer.send_account_rejection(self).deliver_now
    when 'unapproved'
        AdminMailer.send_account_suspension(self).deliver_now
    end
  end

  def name
    "#{first_name} #{last_name}"
  end

  def password_required?
    #having trouble with this when admins are un-approving a current user that was previously approved
    false
    ##self.approved? ? true : false
  end

  def password_match?
    self.errors[:password] << "can't be blank" if password.blank?
    self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
    self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end

  def admin?
    self.role == 'Administrator' or self.role == 'Vetter'
  end

  ## auth methods for devise
  def active_for_authentication? 
    super && approved? 
  end 

  def inactive_message 
    if !approved? 
      :not_approved 
    else 
      super # Use whatever other message 
    end 
  end

  def regional_approvers
    region = self.affiliate.region
    User.approvers.select {|user| user.affiliate.region == region}
  end
  ## end of auth methods for devise
end
