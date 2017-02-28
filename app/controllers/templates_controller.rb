class TemplatesController < ApplicationController

  before_action :authenticate_user!
  
  # POST /campaigns/1/templates
  def create
    @template = Template.new(template_params)

    if @template.save
      redirect_to campaign_template_path(@template.campaign, @template), notice: "Template created!"
    else
      render :new
    end
  end

  # DELETE /campaigns/1/templates
  def destroy
    @template = Template.find(params[:id])
  end

  # GET /campaigns/1/templates/1/edit
  def edit
    @template = Template.includes(:campaign).find(params[:id])
    @campaigns = Campaign.all
  end

  # GET /campaigns/1/templates
  def index
    @templates = Template.includes(:campaign).all
    @campaign = Campaign.find(params[:campaign_id])
  end

  # GET /campaigns/1/templates/new
  def new
    @template = Template.new(campaign_id: params[:campaign_id])
    @campaign = Campaign.find(params[:campaign_id])
    @campaigns = Campaign.all
  end

  # GET /campaigns/1/templates/1
  def show
    @template = Template.includes(:campaign).find(params[:id])
    @campaign = Campaign.find(params[:campaign_id])
  end

  # PATCH /campaigns/1/templates/1
  def update
    @template = Template.includes(:campaign).find(params[:id])

    if @template.update_attributes(template_params)
      redirect_to campaign_template_path(@template.campaign, @template), notice: "Template updated!"
    else
      render :edit, alert: "Cannot update template!"
    end
  end

  private

  def template_params
    params.require(:template).permit(:title, :description, :height, :width, :pdf_markup, :form_markup, :status, :thumbnail, :numbered_image, :blank_image, :customizable_options, :campaign_id)
  end
end
