class ApplicationPolicy
  attr_reader :current_user, :record

  def initialize(user, record)
    @current_user = user
    @record = record
  end

  def scope
    Pundit.policy_scope!(current_user, record.class)
  end

  class Scope
    attr_reader :current_user, :scope

    def initialize(user, scope)
      @current_user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  def current_user_can_access_campaign?
    campaign = case @record
    when Campaign
      @record
    when Document
      if @record.persisted?
        @record.template.campaigns.to_a
      else
        Template.find(@record.template_id).campaigns.to_a
      end
    when Template
      @record.campaigns.to_a
    else
      return false
    end

    case campaign
    when Campaign
      # Does the user have access to the record's campaign?
      @current_user.campaigns.include?(campaign)
    when Array
      if campaign.length == 0
        # Document's template does not belong to any campaigns. Allow access.
        true
      else
        # Does the campaign array share any IDs with the current_user's campaigns?
        (@current_user.campaigns.map(&:id) & campaign.map(&:id)).length > 0
      end
    else
      # Any other kind of data should not allow access
      false
    end
  end

  def current_user_is_owner_or_admin?
    current_user_is_admin? || @record.creator_id == @current_user.id
  end

  def current_user_is_admin_or_vetter?
    current_user_is_admin? || current_user_is_vetter?
  end

  def current_user_is_admin?
    @current_user.admin?
  end

  def current_user_is_vetter?
    @current_user.vetter?
  end

  def record_is_current_user?
    @record == @current_user
  end

  def record_is_published?
    @record&.status == "publish"
  end
end
