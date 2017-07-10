class ActionView::Helpers::FormBuilder
  # Overriden from: https://github.com/rsantamaria/papercrop/blob/v0.3.0/lib/papercrop/helpers.rb#L31-L64
  # Papercrop only crops the default style, but we need to crop the 'cropped' style.
  # Form field names still contain 'original' instead of the name of the style
  # because there is code throughout Papercrop that assumes this is the original image.
  def cropbox(attachment, style = :original, opts = {})
    attachment   = attachment.to_sym
    style_width  = self.object.image_geometry(attachment, style).width.to_i
    style_height = self.object.image_geometry(attachment, style).height.to_i
    box_width    = opts.fetch :width,  style_width
    aspect       = opts.fetch :aspect, self.object.send(:"#{attachment}_aspect")

    if self.object.send(attachment).class == Paperclip::Attachment
      box  = self.hidden_field(:"#{attachment}_original_w", value: style_width)
      box << self.hidden_field(:"#{attachment}_original_h", value: style_height)
      box << self.hidden_field(:"#{attachment}_box_w",      value: box_width)
      box << self.hidden_field(:"#{attachment}_aspect",     value: aspect, id: "#{attachment}_aspect")
      
      for attribute in [:crop_x, :crop_y, :crop_w, :crop_h] do
        box << self.hidden_field(:"#{attachment}_#{attribute}", id: "#{attachment}_#{attribute}")
      end

      crop_image = @template.image_tag(self.object.send(attachment).url(style))

      box << @template.content_tag(:div, crop_image, id: "#{attachment}_cropbox")
    end
  end

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
