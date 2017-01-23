class ActionView::Helpers::FormBuilder
  def status_select(options={})
    @template.select_tag(
      status_field_name,
      @template.options_for_select([["Draft", "draft"], ["Publish", "publish"], ["Archive", "archive"]], @object.status),
      options
    )
  end

  private

  def status_field_name
    "#{@object_name}[status]"
  end
end
