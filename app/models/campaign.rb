class Campaign < ApplicationRecord
  include Status
  include Tree

  has_many :templates
  has_and_belongs_to_many :users, join_table: :campaigns_users

  validates_presence_of :title
end
