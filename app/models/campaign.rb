class Campaign < ApplicationRecord
  include Status
  include Tree

  has_and_belongs_to_many :templates, join_table: :campaigns_templates
  has_and_belongs_to_many :users,     join_table: :campaigns_users

  validates_presence_of :title
end
