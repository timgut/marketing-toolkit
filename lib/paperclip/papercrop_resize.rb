module Paperclip
  class PapercropResize < Thumbnail
    attr_accessor :resize_height, :resize_width

    def target
      @target ||= @attachment.instance
    end

    def transformation_command
      if target.strategy == :papercrop && target.paperclip_resize
        self.resize_height = target.resize_height
        self.resize_width  = target.resize_width

        command = ["-resize", "#{resize_width}x#{resize_height}!"]
        target.commands << command
        command
      else
        super
      end
    end
  end
end
