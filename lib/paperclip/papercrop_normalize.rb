module Paperclip
  class PapercropNormalize < Thumbnail
    MAX_SIZE = 1500.0

    attr_accessor :new_height, :new_width, :aspect

    def target
      @target ||= @attachment.instance
    end

    def transformation_command
      if target.strategy == :papercrop && (target.image.width > MAX_SIZE || target.image.height > MAX_SIZE)
        case target.orientation
        when :landscape
          self.aspect = (MAX_SIZE / target.image.width.to_f)
        when :portrait
          self.aspect = (MAX_SIZE / target.image.height.to_f)
        end

        self.new_height = (target.image.height * self.aspect).ceil
        self.new_width  = (target.image.width  * self.aspect).ceil
        # puts "\n\n\n\n#{target.orientation} ==> ASPECT IS @ #{aspect} and NEW HEIGHT IS @ #{new_height} and NEW WIDTH is #{new_width}\n\n\n\n"

        command = ["-resize", "#{self.new_width}x#{self.new_height}"]
        target.commands << command
        command
      else
        super
      end
    end
  end
end
