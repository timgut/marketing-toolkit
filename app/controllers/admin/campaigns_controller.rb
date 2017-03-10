class Admin::CampaignsController < ApplicationController

  before_action :require_admin

  # POST /users
  def create
    @new_campaign = Campaign.new(campaign_params)
    if @new_campaign.save
      @campaign = Campaign.new
      @campaigns = Campaign.all
      redirect_to admin_campaigns_path, notice: "Campaign created !"
    else
      render :new
    end
  end

  # DELETE /users
  def destroy
    @campaign = Campaign.find(params[:id])
  end

  # GET /users/1/edit
  def edit
    @campaign = Campaign.find(params[:id])
    @body_class = 'toolkit campaign'
    @header_navigation = true
  end

  # GET /users
  def index
    @campaigns = Campaign.all
  end

  # GET /users/new
  def new
    @campaign = Campaign.new
  end

  # GET /users/1
  def show
    @campaign = Campaign.find(params[:id])
  end

  # PATCH /admin/campaigns/1
  def update
    @campaign = Campaign.find(params[:id])

    if @campaign.update_attributes(campaign_params)
      redirect_to edit_admin_campaign_path(@campaign), notice: "Campaign updated!"
    else
      render :edit, alert: "Cannot update campaign!"
    end
  end

  # DELETE /adminc/ampaigns/1
  def destroy
    @campaign = Campaign.find(params[:id])
    @campaign.destroy
    redirect_to admin_campaigns_path, notice: "Campaign deleted!"
  end

  private

  def campaign_params
    params.require(:campaign).permit(:title, :description, :status)
  end
end