# Run with: load Rails.root.join("db", "paperclip", "migrate.rb")
# require "byebug"
require "rexml/document"
include REXML

# ###
# # Tables to migrate as-is
# ###
# ["affiliates", "ar_internal_metadata", "campaigns_templates", "campaigns_users", "campaigns", "categories", "documents_users", "images_users", "schema_migrations", "users"].each do |table|
#   ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
#   line_num = 0
#   columns = nil
#   File.open(Rails.root.join("db", "paperclip", "data", "#{table}.csv")).read.each_line do |line|
#     if line_num == 0
#       columns = line.gsub('"', '`')
#     else
#       row = line.encode('cp1252', invalid: :replace)
#       # puts "INSERT into `#{table}` (#{columns}) VALUES (#{row})"
#       ActiveRecord::Base.connection.execute("INSERT into `#{table}` (#{columns}) VALUES (#{row})")
#     end

#     line_num += 1
#   end
# end

# ###
# # The data table is migrated as-is, but needs to use xml because of line breaks
# ###
# ActiveRecord::Base.connection.execute("TRUNCATE data")
# columns = "`id`, `document_id`, `key`, `value`, `created_at`, `updated_at`, `field_id`"
# cells = ""
# doc = REXML::Document.new(File.new(Rails.root.join("db", "paperclip", "data", "data.xml")).read.encode('cp1252', invalid: :replace))
# doc.root.elements["data"].select{|t| t.is_a?(REXML::Element)}.each do |row|
#   cells = [
#     row.elements["id"].text,
#     row.elements["document_id"].text,
#     %Q("#{(row.elements["key"].text || "").gsub('"', '\"')}"),
#     %Q("#{(row.elements["value"].text || "").gsub('"', '\"')}"),
#     %Q('#{row.elements["created_at"].text}'),
#     %Q('#{row.elements["updated_at"].text}'),
#     %Q("#{(row.elements["field_id"].text || "").gsub('"', '\"')}")
#   ].join(", ")

#   # puts "INSERT into `images` (#{columns}) VALUES (#{cells})"
#   ActiveRecord::Base.connection.execute("INSERT into `data` (#{columns}) VALUES (#{cells})")
# end

###
# Images
###
ActiveRecord::Base.connection.execute("TRUNCATE images")
row = nil
doc = REXML::Document.new(File.new(Rails.root.join("db", "paperclip", "data", "images.xml")))
columns = "`id`, `created_at`, `updated_at`, `creator_id`, `status`, `original_image_url`, `cropped_image_url`, `crop_data`"

# Cache the URLs in this format: {1: {original: "", cropped: ""}}
urls = {}
File.open(Rails.root.join("db", "paperclip", "data", "image_urls.csv")).read.each_line do |line|
  parts = line.split(",")
  urls[parts[0]] = {original: parts[1] || "", cropped: parts[2] || ""}
end

doc.root.elements["images"].select{|t| t.is_a?(REXML::Element)}.each do |row|
  id = row.elements["id"].text

  # We only need the drag part of the crop_data
  if row.elements["crop_data"].text.length > 0
    if drag = row.elements["crop_data"].text.split(":drag:")[1]
      drag = drag.gsub(/(:)(\w)/, '\2').gsub(/"/, "'")
      crop_data = "--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\ndrag: !ruby/hash:ActiveSupport::HashWithIndifferentAccess#{drag}"
    else
      crop_data = "NULL"
    end
  else
    crop_data = "NULL"
  end

  # URLs
  if urls[id]
    original = urls[id][:original].gsub("\n", "")
    cropped = urls[id][:cropped].gsub("\n", "")
  else
    original = ""
    cropped = ""
  end

  # Data for the row
  cells = [
    id,
    %Q('#{row.elements["created_at"].text}'),
    %Q('#{row.elements["updated_at"].text}'),
    row.elements["creator_id"].text,
    row.elements["status"].text,
    %Q("#{original}"),
    %Q("#{cropped}"),
    %Q("#{crop_data}")
  ].join(", ")

  # puts "INSERT into `images` (#{columns}) VALUES (#{cells})"
  ActiveRecord::Base.connection.execute("INSERT into `images` (#{columns}) VALUES (#{cells})")
end

# ###
# # Stock Images
# ###
ActiveRecord::Base.connection.execute("TRUNCATE stock_images")
row = nil
line_num = 0
doc = REXML::Document.new(File.new(Rails.root.join("db", "paperclip", "data", "images.xml")))
columns = "`id`, `title`, `status`, `created_at`, `updated_at`, `label`, `image_url`"

# Cache the URLs in this format: {1: {url: ""}}
urls = {}
File.open(Rails.root.join("db", "paperclip", "data", "stock_image_urls.csv")).read.each_line do |line|
  parts = line.split(",")
  urls[parts[0]] = {image: parts[1]}
end

File.open(Rails.root.join("db", "paperclip", "data", "stock_images.csv")).read.each_line do |line|
  if line_num > 0
    row = line.encode('cp1252', invalid: :replace).split(",")

    if urls[row[0]]
      image = urls[row[0]][:image].gsub("\n", "")
    else
      image = ""
    end

    cells = [
      row[0],
      row[1],
      row[6],
      row[7],
      row[8],
      row[9],
      %Q("#{image}"),
    ].join(", ")
    # puts "INSERT into `stock_images` (#{columns}) VALUES (#{cells})"
    ActiveRecord::Base.connection.execute("INSERT into `stock_images` (#{columns}) VALUES (#{cells})")
  end

  line_num += 1
end


# # ###
# # # Documents
# # ###
# ActiveRecord::Base.connection.execute("TRUNCATE documents")
# row = nil
# doc = REXML::Document.new(File.new(Rails.root.join("db", "paperclip", "data", "documents.xml")).read.encode('cp1252', invalid: :replace))
# columns = "`id`, `template_id`, `title`, `description`, `status`, `created_at`, `updated_at`, `tag_id`, `creator_id`, `crop_marks`, `pdf_url`, `thumbnail_url`, `share_graphic_url`, `generated`"

# # Cache the URLs in this format: {1: {pdf: "", thumbnail: "", share_graphic: ""}}
# urls = {}
# File.open(Rails.root.join("db", "paperclip", "data", "document_urls.csv")).read.each_line do |line|
#   parts = line.split(",")
#   urls[parts[0]] = {pdf: parts[1] || "", thumbnail: parts[2] || "", share_graphic: parts[3] || ""}
# end

# doc.root.elements["documents"].select{|t| t.is_a?(REXML::Element)}.each do |row|
#   id = row.elements["id"].text

#   # URLs
#   if urls[id]
#     pdf = urls[id][:pdf]
#     thumbnail = urls[id][:thumbnail]
#     share_graphic = urls[id][:share_graphic]
#   else
#     pdf = ""
#     thumbnail = ""
#     share_graphic = ""
#   end

#   # Data for the row
#   cells = [
#     id,
#     row.elements["template_id"].text,
#     %Q("#{row.elements["title"].text.gsub('"', '\"')}"),
#     %Q("#{row.elements["description"].text.gsub('"', '\"')}}"),
#     row.elements["status"].text,
#     %Q('#{row.elements["created_at"].text}'),
#     %Q('#{row.elements["updated_at"].text}'),
#     row.elements["tag_id"].text,
#     row.elements["creator_id"].text,
#     row.elements["crop_marks"].text,
#     %Q("#{pdf}"),
#     %Q("#{thumbnail}"),
#     %Q("#{share_graphic}"),
#     0
#   ].join(", ")

#   # puts "INSERT into `documents` (#{columns}) VALUES (#{cells})"
#   ActiveRecord::Base.connection.execute("INSERT into `documents` (#{columns}) VALUES (#{cells})")
# end

# # ###
# # # Templates
# # ###
# ActiveRecord::Base.connection.execute("TRUNCATE templates")
# row = nil
# doc = REXML::Document.new(File.new(Rails.root.join("db", "paperclip", "data", "templates.xml")).read.encode('cp1252', invalid: :replace))
# columns = "`id`, `title`, `description`, `height`, `width`, `pdf_markup`, `form_markup`, `status`, `customizable_options`,
#     `created_at`, `updated_at`, `category_id`, `orientation`, `customize`, `crop_marks`, `position`, `unit`,
#     `format`, `thumbnail_url`, `numbered_image_url`, `blank_image_url`, `static_pdf_url`"

# # Cache the URLs in this format: {1: {thumbnail: "", numbered_image: "", blank_image: "", static_pdf: ""}}
# urls = {}
# File.open(Rails.root.join("db", "paperclip", "data", "template_urls.csv")).read.each_line do |line|
#   parts = line.split(",")
#   urls[parts[0]] = {thumbnail: parts[1] || "", numbered_image: parts[2] || "", blank_image: parts[3] || "", static_pdf: parts[4] || ""}
# end

# doc.root.elements["templates"].select{|t| t.is_a?(REXML::Element)}.each do |row|
#   id = row.elements["id"].text

#   # URLs
#   if urls[id]
#     thumbnail = urls[id][:thumbnail]
#     numbered_image = urls[id][:numbered_image]
#     blank_image = urls[id][:blank_image]
#     static_pdf = urls[id][:static_pdf]
#   else
#     thumbnail = ""
#     numbered_image = ""
#     blank_image = ""
#     static_pdf = ""
#   end

#   # Data for the row
#   cells = [
#     id,
#     %Q("#{(row.elements["title"].text || "").gsub('"', '\"')}"),
#     %Q("#{(row.elements["description"].text || "").gsub('"', '\"')}"),
#     %Q('#{(row.elements["height"].text || "")}'),
#     %Q('#{(row.elements["width"].text || "")}'),
#     %Q("#{(row.elements["pdf_markup"].text || "").gsub('\"', '"').gsub('"', '\"')}"),
#     %Q("#{(row.elements["form_markup"].text || "").gsub('\"', '"').gsub('"', '\"')}"),
#     row.elements["status"].text,
#     %Q("#{(row.elements["customizable_options"].text || "").gsub('"', '\"')}"),
#     %Q('#{(row.elements["created_at"].text || "")}'),
#     %Q('#{(row.elements["updated_at"].text || "")}'),
#     row.elements["category_id"].text,
#     %Q('#{(row.elements["orientation"].text || "")}'),
#     row.elements["customize"].text,
#     row.elements["crop_marks"].text,
#     row.elements["position"].text,
#     %Q('#{(row.elements["unit"].text || "")}'),
#     %Q('#{(row.elements["format"].text || "")}'),
#     %Q("#{thumbnail}"),
#     %Q("#{numbered_image}"),
#     %Q("#{blank_image}"),
#     %Q("#{static_pdf}")
#   ].join(", ")

#   # puts "INSERT into `templates` (#{columns}) VALUES (#{cells})"
#   ActiveRecord::Base.connection.execute("INSERT into `templates` (#{columns}) VALUES (#{cells})")
# end
