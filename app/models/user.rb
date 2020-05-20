class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :documents
  has_and_belongs_to_many :images
  has_and_belongs_to_many :campaigns, join_table: :campaigns_users

  validates_length_of :first_name, :maximum => 30, :message => "must be less than 30 characters"
  validates_length_of :last_name, :maximum => 30, :message => "must be less than 30 characters"

  belongs_to :affiliate

  scope :approved, -> { where(approved: 1) }
  scope :unapproved, -> { where(approved: 0, rejected: 0) }
  scope :unapproved_and_needs_reminder, -> { where(approved: 0, rejected: 0).where('approval_reminder_sent IS NULL and created_at < ?', DateTime.now - 2.days) }

  scope :rejected, -> { where(rejected: 1) }
  scope :approvers, -> { where(role: 'Vetter') }

  after_create :access_all_campaigns!
  after_create :send_admin_emails

  attr_accessor :quiet # Set to true to disable emails to the user

  ROLES = ['User', 'Local President', 'Vetter', 'Administrator']
  
  DEPARTMENTS = [ 
    'IU-Communications', 
    'IU-Organizing', 
    'IU-Political', 
    'Council-Communications',
    'Council-Organizing', 
    'Council-Political', 
    'Local-President', 
    'Research', 
    'Data & Analytics',
    'Education', 
    'Executive Office',
    'Federal Government Affairs',
    'Information Technology',
    'Retirees'
  ]

  class << self
    def to_csv
      CSV.generate do |csv|
        csv << [
          "ID", "First Name", "Last Name", "Email", "Zip Code", "Cell Phone",
          "Department", "Council", "Local #", "Affiliate", "Vetter Region",
          "Role", "Approved?", "Rejected?", "Receive Alerts?", "Custom Branding?",
          "Sign In Count", "Most Recent Sign In", "Created At", "Approval Reminder Sent At"
        ]

        User.includes(:affiliate).all.order(created_at: :desc).each do |user|
          csv << [
            user.id, user.first_name, user.last_name, user.email, user.zip_code, user.cell_phone,
            user.department, user.council, user.local_number, user.affiliate.title, user.vetter_region,
            user.role, user.approved?, user.rejected?, user.receive_alerts?, user.custom_branding?,
            user.sign_in_count, user.current_sign_in_at, user.created_at, user.approval_reminder_sent
          ]
        end
      end
    end
  end

  def send_account_notification(status)
    unless quiet
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
    self.role == 'Administrator'
  end

  def vetter?
    self.role == 'Vetter'
  end

  def set_accessible_campaigns!(campaigns)
    CampaignUser.where(user_id: id).destroy_all

    Array(campaigns).each do |campaign|
      CampaignUser.create!(campaign_id: campaign, user_id: id)
    end
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
    User.approvers.select {|user| user.vetter_region == region}
  end
  ## end of auth methods for devise
  
  protected

  def send_admin_emails
    AdminMailer.new_user_waiting_for_approval(self).deliver_now
    ## we no longer want to trigger auto-email notifications b/c of possible spam
    # unless self.admin?
    #   AdminMailer.notification_to_approvers(self, self.regional_approvers).deliver_now
    # end
  end

  def access_all_campaigns!
    Campaign.publish.each do |campaign|
      CampaignUser.create!(campaign: campaign, user: self)
    end
  end
end
