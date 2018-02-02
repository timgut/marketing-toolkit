class TemplatesController < ApplicationController
  before_action :assign_sidebar_vars, only: [:index]
  before_action :paginate!,           only: [:index]

  # GET /templates
  def index
    if params[:category_id]
      @filtered_templates = @templates.select{ |template| 
        template.category_id == params[:category_id].to_i 
      }.page(params[:page])

      @category = Category.find(params[:category_id])
    else
      @filtered_templates = @templates.page(params[:page])
    end
  end

  # GET /templates/1
  def show
    load_template
    @campaign = @template.campaign
  end

  private

  def assign_sidebar_vars
    @campaigns =  Campaign.publish.roots
    @templates = Template.publish

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
