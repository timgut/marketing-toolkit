class Affiliate < ApplicationRecord
  has_many :users
  validates_presence_of :title, :region, :state, :slug

  def to_s
  	if state_abbr
  		"#{state_abbr} - #{title}"
  	else
  		title
  	end
  end

  def state_abbr
  	AfscmeToolkit::STATE_NAME_TO_ABBR[state] 
  end
end
