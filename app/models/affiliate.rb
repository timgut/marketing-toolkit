class Affiliate < ApplicationRecord
  has_many :users
  validates_presence_of :title, :region, :state, :slug

  def to_s
  	if self.state_abbr
  		"#{self.state_abbr} - #{self.title}"
  	else
  		self.title
  	end
  end

  def state_abbr
  	AfscmeToolkit::STATE_NAME_TO_ABBR[self.state] 
  end

end
