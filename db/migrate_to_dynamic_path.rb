# In the console, call: load "#{Rails.root}/db/migrate_to_dynamic_path.rb"

require 'net/http'

BASE_URL = "s3.amazonaws.com"
DIR      = "/Users/jarred/Desktop/toolkit/" # CHANGE THIS! ADD A TRAILING SLASH!

Image.find_each do |image|
  puts "\nImage ##{image.id}\n---------\n"
  
  if image.image_file_name.blank?
    puts "image_file_name is blank\n"
  else
    original = ""
    cropped  = ""
    filename = "#{DIR}#{image.image_file_name}"

    Net::HTTP.start(BASE_URL) do |http|
      original_file_name = "/toolkit.afscme.org/images/images/000/000/#{image.id}/original/#{image.image_file_name}"
      original           = http.get original_file_name
      cropped_file_name  = "/toolkit.afscme.org/images/images/000/000/#{image.id}/cropped/#{image.image_file_name}"
      cropped            = http.get cropped_file_name
      
      # Save the original file locally if it exists at S3.
      if original.code == "200"
        open("#{filename}", "wb"){|file| file.write(original.body)}
        puts "Saved locally to #{filename}\n"
      else
        puts "#{original_file_name} returned #{original.code}\n"
      end

      # Save the cropped file locally if it exists at S3. 
      if cropped.code == "200"
        open("#{filename}", "wb"){|file| file.write(cropped.body)}
        puts "Saved locally to #{filename}\n"
      else
        puts "#{BASE_URL}#{cropped_file_name} returned #{cropped.code}\n"
      end
    end

    if original.code == "200"
      puts "Re-saving image attachment #{filename}\n"
      new_image = File.new filename
      image.image = new_image
      image.save
      image.image.reprocess! if cropped.code == "200"
    end
  end
end

Template.find_each do |template|
  puts "\nTemplate ##{template.id}\n---------\n"
  [:thumbnail, :numbered_image, :blank_image, :static_pdf].each do |attachment|
    puts "Processing #{attachment}"
    attachment_file_name = template.__send__("#{attachment}_file_name")

    if attachment_file_name.blank?
      puts "#{attachment}_file_name is blank\n"
    else
      Net::HTTP.start(BASE_URL) do |http|
        case template.id.to_s.length
        when 1
          id_with_zeros = "00#{template.id}"
        when 2
          id_with_zeros = "0#{template.id}"
        else
          id_with_zeros = template.id
        end

        request_path = "/toolkit.afscme.org/templates/thumbnails/000/000/#{id_with_zeros}/original/#{attachment_file_name}"
        response     = http.get(request_path)
        
        # Save the original file locally if it exists at S3.
        if response.code == "200"
          filename = "#{DIR}#{attachment_file_name}"

          open("#{filename}", "wb"){|file| file.write(response.body)}
          puts "Saved locally to #{filename}\n"

          new_attachment = File.new filename
          template.__send__("#{attachment}=", new_attachment)
          template.save
        else
          puts "#{BASE_URL}#{request_path} returned #{response.code}\n"
        end
      end
    end
  end
end

Document.find_each do |document|
  puts "\nDocument ##{document.id}\n---------\n"
  if document.pdf_file_name.blank?
    puts "pdf_file_name is blank\n"
  else
    Net::HTTP.start(BASE_URL) do |http|
      case document.id.to_s.length
      when 1
        id_with_zeros = "00#{document.id}"
      when 2
        id_with_zeros = "0#{document.id}"
      else
        id_with_zeros = document.id
      end

      pdf_file_name = "/toolkit.afscme.org/documents/pdfs/000/000/#{id_with_zeros}/original/#{document.pdf_file_name}"
      pdf           = http.get pdf_file_name
      
      # Save the PDF file locally if it exists at S3.
      if pdf.code == "200"
        filename = "#{DIR}#{document.pdf_file_name}"

        open("#{filename}", "wb"){|file| file.write(pdf.body)}
        puts "Saved locally to #{filename}\n"

        new_document = File.new filename
        document.pdf = new_document
        document.save
      else
        puts "#{BASE_URL}#{pdf_file_name} returned #{pdf.code}\n"
      end
    end
  end
end
