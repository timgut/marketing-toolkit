class CampaignsController < ApplicationController
  before_action :assign_sidebar_vars, only: [:index, :show]

  # GET /campaigns
  def index
    @campaigns = current_user.campaigns.publish.roots
  end

  # GET /campaigns/1
  def show
    @campaign = Campaign.includes(:templates, :children).find(params[:id])
    authorize_campaign!(@campaign)
    @filtered_templates = @campaign.templates.publish
  end

  protected

  def assign_sidebar_vars
    @campaigns = current_user.campaigns.publish.roots.includes(:templates).order(title: :asc)

    @templates = @campaigns.inject([]) do |templates, campaign|
      templates << campaign.templates.publish
    end.flatten

    @sidebar_vars = @categories.inject([]) do |sidebar_vars, category|
      sidebar_vars << {
        category_id: category.id,
        title:       category.title,
        items:       @templates.select{|template| template.category_id == category.id }
      }
    end
  end
end
