module Trashable
  extend ActiveSupport::Concern
  
  included do
    before_action :set_record, only: [:destroy, :restore, :trash]
  end

  # DELETE /#{model}/1
  def destroy
    if @record.status == "trash"
      if @record.destroy
        trashable_redirect notice: "#{model_var.capitalize} destroyed!"
      else
        trashable_redirect alert: "Cannot destroy #{model_var}. Please try again."
      end
    else
      trashable_redirect alert: "This #{model_var} must be placed in the trash before it can be destroyed."
    end
  end

  # PATCH /#{model}/1/restore
  def restore
    if @record.update_attributes(status: "publish")
      trashable_redirect notice: "#{model_var.capitalize} restored!"
    else
      trashable_redirect alert: "Cannot restore #{model_var}. Please try again."
    end
  end

  # PATCH /#{model}/1/trash
  def trash
    if @record.update_attributes(status: "trash")
      trashable_redirect notice: "#{model_var.capitalize} was moved to the trash!"
    else
      trashable_redirect alert: "Cannot send #{model_var} to the trash. Please try again."
    end
  end

  # GET /#{model}/trashed
  def trashed
  end

  private

  # Extracts the model name as a string from the controller, such as "image".
  def model_var
    @model_var ||= request.filtered_parameters["controller"].split('/').last.singularize
  end

  # Get the controller's model class, such as ::Image.
  def model
    @model ||= model_var.camelize.constantize
  end

  # Helper that sets @record for easy access.
  def set_record
    @record = instance_variable_set("@#{model_var}".to_sym, model.find(params[:id]))
  end

  # All of these actions redirect similarly, so this cuts down on the repetition.
  def trashable_redirect(opts={})
    redirect_back({fallback_location: authenticated_root_path}.merge(opts))
  end
end