module Paperclip
  class Resize < Thumbnail
    def target
      @target ||= @attachment.instance
    end

    def transformation_command
      Rails.logger.info "*"*60
      Rails.logger.info "Running Paperclip::Resize#transformation_command"
      Rails.logger.info "target.resizing? #{target.resizing?.inspect}"
      if target.resizing?
        ["-resize", "#{target.image_size_h}x#{target.image_size_w}"]
      else
        super
      end
    end
  end
end
