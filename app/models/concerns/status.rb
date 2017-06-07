module Status
  extend ActiveSupport::Concern

  included do
    enum status: {
      trash:   -2,
      archive: -1,
      draft:   0,
      publish: 1
    }

    # These unless calls ensure that scopes are not overwritten since the
    # same scopes are used across several models.
    scope :trash,   ->{ where(status: -2) } unless self.respond_to?(:trash)
    scope :archive, ->{ where(status: -1) } unless self.respond_to?(:archive)
    scope :draft,   ->{ where(status: 0)  } unless self.respond_to?(:draft)
    scope :publish, ->{ where(status: 1)  } unless self.respond_to?(:publish)

    scope :not_trashed,   ->{ where("status != ?", -2) } unless self.respond_to?(:not_trashed)
    scope :not_archived,  ->{ where("status != ?", -1) } unless self.respond_to?(:not_archived)
    scope :not_draft,     ->{ where("status != ?", 0)  } unless self.respond_to?(:not_draft)
    scope :not_published, ->{ where("status != ?", 1)  } unless self.respond_to?(:not_published)  
  end
end
