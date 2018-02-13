class Campaign < ApplicationRecord
  include Status
  include Tree

  has_many :templates
  has_and_belongs_to_many :users, join_table: :campaigns_users

  validates_presence_of :title

  def audit!(message)
    update_attributes(audit: "#{message} on #{DateTime.now.strftime("%D %r")}")
  end
end
