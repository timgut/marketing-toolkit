class ActionView::Helpers::FormBuilder
  def status_select(options={})
    @template.select_tag(
      field_name("status"),
      @template.options_for_select([["Draft", "draft"], ["Publish", "publish"], ["Archive", "archive"]], @object.status),
      options
    )
  end

  private

  def field_name(attribute)
    "#{@object_name}[#{attribute}]"
  end
end
