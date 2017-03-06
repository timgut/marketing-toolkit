class TemplatesController < ApplicationController

  before_action :authenticate_user!
  before_action :assign_sidebar_vars, only: [:index]
  before_action :assign_form_vars,    only: [:edit, :new, :update]
  
  # POST /templates
  def create
    @template = Template.new(template_params)

    if @template.save
      redirect_to template_path(@template), notice: "Template created!"
    else
      render :new
    end
  end

  # DELETE /templates/1
  def destroy
    @template = Template.find(params[:id])
  end

  # GET /templates/1/edit
  def edit
    @template = Template.includes(:campaign).find(params[:id])
  end

  # GET /templates
  def index
    if params[:category_id]
      @filtered_templates = @templates.select{|template| template.category_id == params[:category_id].to_i}
    else
      @filtered_templates = @templates
    end
  end

  # GET /templates/new
  def new
    @template = Template.new(campaign_id: params[:campaign_id])
    @campaign = @template.campaign
  end

  # GET /templates/1
  def show
    @template = Template.includes(:campaign).find(params[:id])
    @campaign = @template.campaign
  end

  # PATCH /templates/1
  def update
    @template = Template.includes(:campaign).find(params[:id])

    if @template.update_attributes(template_params)
      redirect_to template_path(@template), notice: "Template updated!"
    else
      render :edit, alert: "Cannot update template!"
    end
  end

  protected

  def assign_form_vars
    @campaigns = Campaign.all
    @categories = Category.all
  end

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

  private

  def template_params
    params.require(:template).permit(:title, :description, :height, :width, :pdf_markup, :form_markup, :status, :thumbnail, :numbered_image, :blank_image, :customizable_options, :campaign_id)
  end
end
