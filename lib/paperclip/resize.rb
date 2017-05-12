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
          new_height = (context_size[:height] * multiplier).ceil
          new_width = ((target_size[:width] * new_height)/target_size[:height]).ceil
          puts "\n\n\n\nLANDSCAPE ==> NEW HEIGHT IS @ #{new_height} and NEW WIDTH is #{new_width}\n\n\n\n"
        when :portrait
          new_width = (context_size[:width] * multiplier).ceil
          new_height = ((target_size[:height] * new_width)/target_size[:width]).ceil

          puts "\n\n\n\n\nPORTRAIT. NEW WIDTH IS @ #{new_width}\n\n\n\n\n\n\n"

        end
        #new_size = (target.context.crop_bottom - target.context.crop_top) * multiplier
        command = ["-resize", "#{new_width}x#{new_height}^"]
        # command = ["-resize", "#{(context_size[:height] * context_size[:width]) * multiplier}@"]
        target.resize_cmd = command
        command
      else
        super
      end
    end
  end
end
