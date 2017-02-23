module Status
  extend ActiveSupport::Concern

  included do
    enum status: {
      archive: -1,
      draft:   0,
      publish: 1
    }

    scope :archive, ->{ where(status: -1) }
    scope :draft,   ->{ where(status: 0)  }
    scope :publish, ->{ where(status: 1)  }    
  end
end
