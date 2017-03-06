module Status
  extend ActiveSupport::Concern

  included do
    enum status: {
      trash:   -2,
      archive: -1,
      draft:   0,
      publish: 1
    }

    scope :trash,   ->{ where(status: -2) } unless self.respond_to?(:trash)
    scope :archive, ->{ where(status: -1) } unless self.respond_to?(:archive)
    scope :draft,   ->{ where(status: 0)  } unless self.respond_to?(:draft)
    scope :publish, ->{ where(status: 1)  } unless self.respond_to?(:publish)  
  end
end
