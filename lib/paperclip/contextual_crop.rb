module Paperclip
  class ContextualCrop < Thumbnail
    def target
      @target ||= @attachment.instance
    end

    def context
      @context ||= @target.context
    end

    def transformation_command
      if target.cropping?
        # The crop width will always be the width of the context image.
        crop_w = Integer(context.blank_image_width)

        # The crop height is the height of the context image minus the crop_top.
        # Then subtract the number of pixels from the crop_bottom to the bottom
        # of the image. This will return the height of the transparent part of
        # the context image (i.e. the crop height).
        crop_h = Integer(context.blank_image_height - Float(context.blank_image_height - context.crop_bottom) + Float(context.crop_top))
        
        # The x position where the crop starts is pos_x - crop_top.
        if Float(target.pos_x) > Float(context.crop_top)
          crop_x = 0
        else
          crop_x = Integer(Float(target.pos_x) - Float(context.crop_top)).abs
        end
        
        # The y position where the crop starts is pos_y.
        crop_y = Integer(target.pos_y).abs

        ["-crop", "#{crop_w}x#{crop_h}+#{crop_x}+#{crop_y}"]
      else
        super
      end
    end
  end
end
