class Admin::TemplatesController < AdminController
  before_action :assign_form_vars, only: [:edit, :new, :update]

  # POST /admin/templates
  def create
    @template = Template.new(template_params)
    @template.position = Template.publish.count + 1
    authorize @template

    if @template.save
      redirect_to edit_admin_template_path(@template), notice: "Template created! You can now add images."
    else
      assign_form_vars
      render :new
    end
  end

  # DELETE /admin/templates/1
  def destroy
    load_template

    # We don't really ever want to destroy templates. Since Template includes Status, but
    # Admin::TemplatesController does not include Trashable, then we can change the status
    # to "trash" and it will appear deleted since there is no UI to show it. But we can 
    # easily restore it if this deletion was a mistake. 
    if @template.update_attributes(status: -2)
      redirect_back fallback_location: admin_templates_path, notice: "Template destroyed!"
    else
      redirect_back fallback_location: admin_templates_path, alert: "Cannot destroy template. Please try again."
    end
  end

  # GET /admin/templates/1/edit
  def edit
    load_template
  end

  # GET /admin/templates
  def index
    @templates = Template.not_trashed
    authorize @templates
  end

  # GET /admin/templates/new
  def new
    @template = Template.new(campaign_id: params[:campaign_id])
    authorize @template
    @campaign = @template.campaign
  end

  # GET /admin/templates/positions
  def positions
    @templates = Template.publish
  end

  # PATCH /admin/templates/1
  def update
    load_template

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

  # PATCH /admin/templates/update_positions
  def update_positions
    Template.update_positions!(params[:positions])
    redirect_to admin_templates_path, notice: "Template positions updated."
  end

  private

  def assign_form_vars
    @campaigns = Campaign.all
    @categories = Category.all
  end

  def load_template
    @template = Template.includes(:campaign).find(params[:id])
    authorize @template
  end

  def template_params
    params.require(:template).permit(
      :title, :description, :height, :width, :pdf_markup, :form_markup, :status,
      :thumbnail, :numbered_image, :blank_image, :customizable_options, :campaign_id, 
      :category_id, :unit, :crop_top, :crop_bottom, :orientation, :customize, 
      :static_pdf, :crop_marks, :format, :mini_magick_markup
    )
  end
end