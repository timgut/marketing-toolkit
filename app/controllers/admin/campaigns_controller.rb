class Admin::CampaignsController < AdminController
  # POST /admin/campaigns
  def create
    @new_campaign = Campaign.new(campaign_params)
    authorize @new_campaign
    if @new_campaign.save
      @campaign = Campaign.new
      @campaigns = Campaign.all
      redirect_to admin_campaigns_path, notice: "Campaign created!"
    else
      redirect_to :back, fallback_location: authenticated_root_path
    end
  end

  # DELETE /admin/campaigns
  def destroy
    load_campaign
    @campaign.destroy
    redirect_to admin_campaigns_path, notice: "Campaign deleted!"
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
    end
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
