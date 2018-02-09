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
        @record.template.campaign
      else
        Template.find(@record.template_id).campaign
      end
    when Template
      @record.campaign
    else
      return false
    end

    case campaign
    when NilClass
      true # Allow access to any record that has a NULL campaign
    when Campaign
      @current_user.campaigns.include?(campaign) # Does the user have access to the record's campaign?
    else
      false # Any other kind of data should not allow access
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
