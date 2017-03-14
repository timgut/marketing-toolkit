class CampaignsController < ApplicationController
  before_action :assign_sidebar_vars, only: [:index, :show]

  # GET /campaigns
  def index
    @campaigns = Campaign.publish
  end

  # GET /campaigns/1
  def show
    @campaign = Campaign.includes(:templates).find(params[:id])
    @filtered_templates = @campaign.templates
  end

  protected

  def assign_sidebar_vars
    @campaigns = Campaign.includes(:templates).publish('title ASC')
    @templates = Template.publish

    @sidebar_vars = @categories.inject([]) do |sidebar_vars, category|
      sidebar_vars << {
        category_id: category.id,
        title:       category.title,
        items:       @templates.select{|template| template.category_id == category.id && template.campaign_id == nil}
      }
    end
  end

  private

  def campaign_params
    params.require(:campaign).permit(:title, :description, :status)
  end
end
