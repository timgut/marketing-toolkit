module Paperclip
  class ContextualResize < Thumbnail
    attr_accessor :new_height, :new_width

    MULTIPLIER = 1.2

    def target
      @target ||= @attachment.instance
    end

    def context
      @context ||= target.context
    end

    def transformation_command
      if target.strategy == :contextual_crop
        # puts "*"*60
        # puts "ContextualResize"
        target_size   = {height: target.image.height, width: target.image.width }
        context_size  = {height: context.blank_image.height, width: context.blank_image.width }

        case target.orientation
        when :landscape
          self.new_height = (context_size[:height] * MULTIPLIER).ceil
          self.new_width  = ((target_size[:width] * new_height) / target_size[:height]).ceil
          # puts "\n\n\n\nLANDSCAPE ==> NEW HEIGHT IS @ #{new_height} and NEW WIDTH is #{new_width}\n\n\n\n"
        when :portrait
          self.new_width  = (context_size[:width] * MULTIPLIER).ceil
          self.new_height = ((target_size[:height] * new_width) / target_size[:width]).ceil
          # puts "\n\n\n\n\nPORTRAIT. NEW WIDTH IS @ #{new_width}\n\n\n\n\n\n\n"
        end

        command = ["-resize", "#{new_width}x#{new_height}^"]
        target.commands << command
        command
      else
        super
      end
    end
  end
end
