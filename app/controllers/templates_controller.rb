class TemplatesController < ApplicationController
  # POST /templates
  def create
    @template = Template.new(template_params)

    if @template.save
      redirect_to template_path(@template), notice: "Template created!"
    else
      render :new
    end
  end

  # DELETE /templates
  def destroy
    @template = Template.find(params[:id])
  end

  # GET /templates/1/edit
  def edit
    @template = Template.find(params[:id])
  end

  # GET /templates
  def index
    @templates = Template.all
  end

  # GET /templates/new
  def new
    @template = Template.new
  end

  # GET /templates/1
  def show
    @template = Template.find(params[:id])
  end

  # PATCH /templates/1
  def update
    @template = Template.find(params[:id])

    if @template.update_attributes(template_params)
      redirect_to template_path(@template), notice: "Template updated!"
    else
      render :edit, alert: "Cannot update template!"
    end
  end

  private

  def template_params
    params.require(:template).permit(:title, :description, :height, :width, :pdf_markup, :form_markup, :status)
  end
end
