class TemplatesController < ApplicationController
  before_action :assign_sidebar_vars, only: [:index, :trashed]

  # GET /templates
  def index
    if params[:category_id]
      @filtered_templates = @templates.select{|template| template.category_id == params[:category_id].to_i && template.campaign_id == nil }
      @category = Category.find(params[:category_id])
    else
      @filtered_templates = @templates
    end
  end

  # GET /templates/1
  def show
    @template = Template.includes(:campaign).find(params[:id])
    @campaign = @template.campaign
  end

  private

  def assign_sidebar_vars
    @campaigns = Campaign.active
    @templates = Template.all

    @sidebar_vars = @categories.inject([]) do |sidebar_vars, category|
      sidebar_vars << {
        category_id: category.id,
        title:       category.title,
        items:       @templates.select{|template| template.category_id == category.id && template.campaign_id == nil}
      }
    end
  end

  def template_params
    params.require(:template).permit(
      :title, :description, :height, :width, :pdf_markup, :form_markup, :status, :thumbnail,
      :numbered_image, :blank_image, :customizable_options, :campaign_id, :category_id, :orientation
    )
  end
end
