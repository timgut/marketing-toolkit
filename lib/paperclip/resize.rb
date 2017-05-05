module Paperclip
  class Resize < Thumbnail
    def target
      @target ||= @attachment.instance
    end

    def transformation_command
      if target.resizing?
        byebug
        # ["-resize", "#{crop_w}x#{crop_h}+#{crop_x}+#{crop_y}"]
      else
        super
      end
    end
  end
end
