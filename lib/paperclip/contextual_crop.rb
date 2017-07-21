module Paperclip
  class ContextualCrop < Thumbnail
    def target
      @target ||= @attachment.instance
    end

    def context
      @context ||= target.context
    end

    def transformation_command
      if target.strategy == :contextual_crop && target.pos_x && target.pos_y
        # puts "*"*60
        # puts "ContextualCrop"
        # The crop width will always be the width of the context image.
        crop_w = Integer(context.blank_image.width)

        # The crop height is the height of the transparent part of the image.
        # crop_h = Integer(context.crop_bottom - context.crop_top)
        crop_h = Integer(context.blank_image.height)
        
        # The x position where the crop starts is pos_x.
        crop_x = Integer(Float(target.pos_x).abs)

        # The y position where the crop starts is pos_y - crop_top.
        # if Float(target.pos_y) > Float(context.crop_top)
        #   crop_y = 0
        # else
        crop_y = Integer(Float(target.pos_y).abs) #Integer(Float(target.pos_y).abs - Float(context.crop_top)).abs
        # end

        command = ["-crop", "#{crop_w}x#{crop_h}+#{crop_x}+#{crop_y}"]
        target.commands << command
        command
      else
        super
      end
    end
  end
end
