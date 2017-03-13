class TemplatesController < ApplicationController
  before_action :assign_sidebar_vars, only: [:index]

  # GET /templates
  def index
    if params[:category_id]
      @filtered_templates = @templates.select{|template| template.category_id == params[:category_id].to_i}
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
    @campaigns = Campaign.includes(:templates).all
    @templates = Template.all

    @sidebar_vars = @categories.inject([]) do |sidebar_vars, category|
      sidebar_vars << {
        category_id: category.id,
        title:       category.title,
        items:       @templates.select{|template| template.category_id == category.id}
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
