class StockImage < ApplicationRecord
    include Status
  
    has_attached_file(
      :image,
      storage:        :s3,
      s3_protocol:    "https",
      s3_credentials: Proc.new{|i| i.instance.__send__(:s3_credentials)},
      path:           "stock_image",
      style:         {thumb: '100x100>', medium: '450x450>'}
    )
  
    crop_attached_file :image
    
    validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
    validates_uniqueness_of :image_file_name
      
    serialize :crop_data, Hash
  
    ##before_post_process :give_unique_filename
  
    attr_accessor :pos_x,           # contextual_crop setting: the X position of the image within the context image.
                  :pos_y,           # contextual_crop setting: the Y position of the image within the context image.
                  :context,         # The Template record to use for contextual cropping.
                  :commands,        # An array of commands sent to ImagMagick.
                  :resize_height,   # The target height to for images cropped with Papercrop.
                  :resize_width,    # The target width to for images cropped with Papercrop.
                  :strategy,        # Set to :papercrop or :contextual_crop to enable the processors.
                  :paperclip_resize # Set to true to enable the PaperclipResize processor.
  
    class << self
      def find_by_url(url)
        file_name = url.split("/").last
        begin
          StockImage.find_by!(image_file_name: file_name)
        rescue ActiveRecord::RecordNotFound
          false # Don't raise an error if the image isn't found
        end
      end
    end
  
    def orientation
      image.width > image.height ? :landscape : :portrait
    end
  
    def reset_crop_data
      self.crop_data = {}
    end
  
    def reset_commands
      self.commands = []
    end
  
    def set_crop_data!
      update_attributes(crop_data: {
        commands: self.commands,
        drag:     {x: self.pos_x, y: self.pos_y}
      })
    end
  
    # Unique filename consist of two dashes (--) and a 10 digit timestamp.
    # If a filename does not contain these characters, we consider it
    # to not be unique.
    # def has_unique_filename?
    #   self.image_file_name.scan(/--\d{10}/).length > 0
    # end
  
    # protected
  
    # # Renames image.png to image--1234567890.png
    # # Renames my.image.gif to my.image--1234567890.gif
    # def give_unique_filename
    #   unless has_unique_filename?
    #     separator  = "."
    #     file_parts = self.image_file_name.split(separator)
    #     file_type  = file_parts.pop
    #     file_name  = file_parts.join(separator) + "--#{DateTime.now.to_i}"
  
    #     self.image_file_name = "#{file_name}#{separator}#{file_type}"
    #   end
    # end
  end
  