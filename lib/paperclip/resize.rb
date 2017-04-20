module Paperclip
  class Resize < Thumbnail
    def target
      @target ||= @attachment.instance
    end

    def transformation_command
      binding.irb
      if target.resizing?
        ["-resize", "#{target.image_size_h}x#{target.image_size_w}"]
      else
        super
      end
    end
  end
end
