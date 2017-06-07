class CampaignsController < ApplicationController
  before_action :assign_sidebar_vars, only: [:index, :show]

  # GET /campaigns
  def index
    @campaigns = Campaign.publish.roots
  end

  # GET /campaigns/1
  def show
    @campaign = Campaign.includes(:templates, :children).find(params[:id])
    @filtered_templates = @campaign.templates.publish
  end

  protected

  def assign_sidebar_vars
    @campaigns = Campaign.publish.roots.includes(:templates).publish('title ASC')
    @templates = Template.publish

    @sidebar_vars = @categories.inject([]) do |sidebar_vars, category|
      sidebar_vars << {
        category_id: category.id,
        title:       category.title,
        items:       @templates.select{|template| template.category_id == category.id }
      }
    end
  end
end
