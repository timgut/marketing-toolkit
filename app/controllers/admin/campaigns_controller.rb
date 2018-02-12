class Admin::CampaignsController < AdminController
  # PUT /admin/campaigns/1/blacklist
  def blacklist
    CampaignUser.where(campaign_id: params[:id]).destroy_all
    redirect_to admin_campaigns_path, notice: "Campaign blacklisted! No one can access its templates."
  end

  # POST /admin/campaigns
  def create
    @new_campaign = Campaign.new(campaign_params)
    authorize @new_campaign

    if @new_campaign.save
      @campaign = Campaign.new
      @campaigns = Campaign.all
      redirect_to admin_campaigns_path, notice: "Campaign created!"
    else
      redirect_back fallback_location: authenticated_root_path, alert: alert_message
    end
  end

  # DELETE /admin/campaigns
  def destroy
    load_campaign
    
    if @campaign.destroy
      redirect_to admin_campaigns_path, notice: "Campaign deleted!"
    else
      redirect_back fallback_location: authenticated_root_path, alert: alert_message
    end
  end

  # GET /admin/campaigns/1/edit
  def edit
    load_campaign
    @body_class = 'toolkit campaign'
    @header_navigation = true
  end

  # GET /admin/campaigns
  def index
    @campaigns = Campaign.all
    authorize @campaigns
  end

  # PATCH /admin/campaigns/1
  def update
    load_campaign

    if @campaign.update_attributes(campaign_params)
      redirect_to edit_admin_campaign_path(@campaign), notice: "Campaign updated!"
    else
      render :edit, alert: "Cannot update campaign!"
      @body_class = 'toolkit campaign'
      @header_navigation = true
    end
  end

  # PUT /admin/campaigns/1/whitelist
  def whitelist
    User.approved.each do |user|
      CampaignUser.find_or_create_by(campaign_id: params[:id], user_id: user.id)
    end

    redirect_to admin_campaigns_path, notice: "Campaign whitelisted! Everyone can access its templates."
  end

  private

  def campaign_params
    params.require(:campaign).permit(:title, :description, :status, :parent_id)
  end

  def load_campaign
    @campaign = Campaign.find(params[:id])
    authorize @campaign
  end
end
