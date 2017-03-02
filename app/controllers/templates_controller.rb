class TemplatesController < ApplicationController

  before_action :authenticate_user!
  
  # POST /templates
  def create
    @template = Template.new(template_params)

    if @template.save
      redirect_to template_path(@template.campaign, @template), notice: "Template created!"
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
    @campaigns = Campaign.all
  end

  # GET /templates
  def index
    @templates = Template.includes(:campaign).all
  end

  # GET /templates/new
  def new
    @template = Template.new(campaign_id: params[:campaign_id])
    @campaign = @template.campaign
    @campaigns = Campaign.all
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
      redirect_to template_path(@template.campaign, @template), notice: "Template updated!"
    else
      render :edit, alert: "Cannot update template!"
    end
  end

  private

  def template_params
    params.require(:template).permit(:title, :description, :height, :width, :pdf_markup, :form_markup, :status, :thumbnail, :numbered_image, :blank_image, :customizable_options, :campaign_id)
  end
end
