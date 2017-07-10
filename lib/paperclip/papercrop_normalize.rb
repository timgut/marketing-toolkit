module Paperclip
  class PapercropNormalize < Thumbnail
    MAX_SIZE = 1500.0

    def target
      @target ||= @attachment.instance
    end

    def transformation_command
      if target.strategy == :papercrop && (target.image.width > MAX_SIZE || target.image.height > MAX_SIZE)
        case target.orientation
        when :landscape
          aspect = (MAX_SIZE / target.image.width.to_f)
        when :portrait
          aspect = (MAX_SIZE / target.image.height.to_f)
        end

        new_height = (target.image.height * aspect).ceil
        new_width  = (target.image.width  * aspect).ceil
        # puts "\n\n\n\n#{target.orientation} ==> ASPECT IS @ #{aspect} and NEW HEIGHT IS @ #{new_height} and NEW WIDTH is #{new_width}\n\n\n\n"

        command = ["-resize", "#{new_width}x#{new_height}"]
        target.commands << command
        command
      else
        super
      end
    end
  end
end
