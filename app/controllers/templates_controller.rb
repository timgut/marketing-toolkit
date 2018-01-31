class TemplatesController < ApplicationController
  before_action :assign_sidebar_vars, only: [:index]

  # GET /templates
  def index
    if params[:category_id]
      @filtered_templates = @templates.select{|template| template.category_id == params[:category_id].to_i }
      @category = Category.find(params[:category_id])
    else
      @filtered_templates = @templates
    end
  end

  # GET /templates/1
  def show
    load_template
    @campaign = @template.campaign
    authorize_campaign!(@campaign)
  end

  private

  def assign_sidebar_vars
    @campaigns = current_user.campaigns.publish.roots

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

  def load_template
    @template = Template.includes(:campaign).find(params[:id])
    authorize @template
  end
end
