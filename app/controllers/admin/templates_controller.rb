class Admin::TemplatesController < AdminController
  before_action :assign_form_vars, only: [:edit, :new, :update]

  # POST /admin/templates
  def create
    @template = Template.new(template_params)

    if @template.save
      redirect_to edit_admin_template_path(@template), notice: "Template created! You can now add images."
    else
      assign_form_vars
      render :new
    end
  end

  # DELETE /admin/templates/1
  def destroy
    @template = Template.find(params[:id])

    if @template.destroy
      redirect_to :back, fallback_location: admin_templates_path, notice: "Template deleted!"
    else
      redirect_to :back, fallback_location: admin_templates_path, alert: "Cannot delete template. Please try again."
    end
  end

  # GET /admin/templates/1/edit
  def edit
    @template = Template.includes(:campaign).find(params[:id])
  end

  # GET /admin/templates
  def index
    @templates = Template.all
  end

  # GET /admin/templates/new
  def new
    @template = Template.new(campaign_id: params[:campaign_id])
    @campaign = @template.campaign
  end

  # PATCH /admin/templates/1
  def update
    @template = Template.includes(:campaign).find(params[:id])

    respond_to do |format|
      format.html do
        if @template.update_attributes(template_params)
          redirect_to edit_admin_template_path(@template), notice: "Template updated!"
        else
          render :edit, alert: "Cannot update template!"
        end
      end

      format.json do
        @template.update_attributes(template_params)
        head :no_content
      end
    end
  end

  private

  def assign_form_vars
    @campaigns = Campaign.all
    @categories = Category.all
  end

  def template_params
    params.require(:template).permit(
      :title, :description, :height, :width, :pdf_markup, :form_markup, :status, :thumbnail,
      :numbered_image, :blank_image, :customizable_options, :campaign_id, :category_id,
      :customize, :static_pdf
    )
  end
end