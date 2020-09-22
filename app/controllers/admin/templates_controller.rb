class Admin::TemplatesController < AdminController
  before_action :assign_form_vars, only: [:edit, :new, :update]

  # POST /admin/templates
  def create
    campaign_params = params[:template].delete(:campaigns)

    @template = Template.new(template_params)
    @template.position = Template.publish.count + 1
    authorize @template

    if @template.save
      @template.set_campaigns!(campaign_params)
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
    @template = Template.new
    authorize @template
  end

  # GET /admin/templates/positions
  def positions
    @templates = Template.publish
  end

  # PATCH /admin/templates/1/remove_image
  def remove_image
    load_template
    # The value of params[:image] is the image to remove
    @template.update_attributes("#{params[:image]}": nil)

    redirect_back fallback_location: admin_templates_path, notice: "Image removed!"
  end

  # PATCH /admin/templates/1
  def update
    load_template

    respond_to do |format|
      format.html do
        campaign_params = params[:template].delete(:campaigns)

        if @template.update_attributes(template_params)
          @template.set_campaigns!(campaign_params)
          redirect_to edit_admin_template_path(@template), notice: "Template updated!"
        else
          render :edit, alert: "Cannot update template!"
        end
      end

      format.json do
        s3_url = "https://s3.amazonaws.com/toolkit.afscme.org/#{@template.s3_path(filename: params[:file].original_filename)}"
        @template.upload_image_to_s3(params[:file])
        @template.update(params[:type] => s3_url)
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
    @campaigns = Campaign.publish
    @categories = Category.all
  end

  def load_template
    @template = Template.find(params[:id])
    authorize @template
  end

  def template_params
    params.require(:template).permit!
  end
end