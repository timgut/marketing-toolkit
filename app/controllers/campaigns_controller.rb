class CampaignsController < ApplicationController
  # POST /campaigns
  def create
    @campaign = Campaign.new(campaign_params)

    if @campaign.save
      redirect_to campaign_path(@campaign), notice: "Campaign created!"
    else
      render :new
    end
  end

  # DELETE /campaigns
  def destroy
    @campaign = Campaign.find(params[:id])
  end

  # GET /campaigns/1/edit
  def edit
    @campaign = Campaign.find(params[:id])
  end

  # GET /campaigns
  def index
    @campaigns = Campaign.includes(:templates).all
  end

  # GET /campaigns/new
  def new
    @campaign = Campaign.new
  end

  # GET /campaigns/1
  def show
    @campaign = Campaign.find(params[:id])
  end

  # PATCH /campaigns/1
  def update
    @campaign = Campaign.find(params[:id])

    if @campaign.update_attributes(campaign_params)
      redirect_to campaign_path(@campaign), notice: "Campaign updated!"
    else
      render :edit, alert: "Cannot update campaign!"
    end
  end

  private

  def campaign_params
    params.require(:campaign).permit(:title, :description, :status)
  end
end
