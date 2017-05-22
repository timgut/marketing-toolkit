module Paperclip
  class Resize < Thumbnail
    def target
      @target ||= @attachment.instance
    end

    def transformation_command
      if target.resizing?
        target_size   = {height: target.image.height, width: target.image.width }
        context_size  = {height: target.context.blank_image.height, width: target.context.blank_image.width }
        multiplier    = 1.2

        case target.orientation
        when :landscape
          new_height = (context_size[:height] * multiplier).ceil
          new_width  = ((target_size[:width] * new_height) / target_size[:height]).ceil
          ##puts "\n\n\n\nLANDSCAPE ==> NEW HEIGHT IS @ #{new_height} and NEW WIDTH is #{new_width}\n\n\n\n"
        when :portrait
          new_height = ((target_size[:height] * new_width) / target_size[:width]).ceil
          new_width  = (context_size[:width] * multiplier).ceil
          ##puts "\n\n\n\n\nPORTRAIT. NEW WIDTH IS @ #{new_width}\n\n\n\n\n\n\n"
        end
        command = ["-resize", "#{new_width}x#{new_height}^"]
        target.resize_cmd = command
        command
      else
        super
      end
    end
  end
end
