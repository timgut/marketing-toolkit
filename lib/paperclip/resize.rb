module Paperclip
  class Resize < Thumbnail
    def target
      @target ||= @attachment.instance
    end

    def transformation_command
      if target.resizing?
        target_size  = target.dimensions(:image)
        context_size = target.context.dimensions(:blank_image)
        multiplier   = 1.2
        orientation  = target_size[:width] > target_size[:height] ? :landscape : :portrait

        case orientation
        when :landscape
          new_size = (context_size[:height] * multiplier).ceil
        when :portrait
          new_size = (context_size[:width] * multiplier).ceil
        end

        ["-resize", "#{new_size}x#{new_size}"]
      else
        super
      end
    end
  end
end
