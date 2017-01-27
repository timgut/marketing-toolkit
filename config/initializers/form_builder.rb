class ActionView::Helpers::FormBuilder
  def status_select(options={})
    @template.select_tag(
      field_name("status"),
      @template.options_for_select([["Draft", "draft"], ["Publish", "publish"], ["Archive", "archive"]], @object.status),
      options
    )
  end

  def folder_select(options={})
    @template.select_tag(
      field_name("folder_id"),
      @template.options_from_collection_for_select(User.current_user.__send__(options[:type].underscore.pluralize), "id", "path"),
      options
    )
  end

  private

  def field_name(attribute)
    "#{@object_name}[#{attribute}]"
  end
end
