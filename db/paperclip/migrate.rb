# Run with: load Rails.root.join("db", "paperclip", "migrate.rb")
# require "byebug"
require "rexml/document"
include REXML

# ###
# # Tables to migrate as-is
# ###
# [
#   "affiliates", "ar_internal_metadata", "campaigns_templates", "campaigns_users", "campaigns", "categories",
#   # "data",
#   "documents_users", "images_users", "schema_migrations", "users"
# ].each do |table|
#   ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
#   line_num = 0
#   columns = nil
#   row = nil

#   File.open(Rails.root.join("db", "paperclip", "data", "#{table}.csv")).read.each_line do |line|
#     if line_num == 0
#       columns = line.gsub('"', '`')
#     else
#       row = line.encode('UTF-8', invalid: :replace)
#       puts "INSERT into `#{table}` (#{columns}) VALUES (#{row})"
#       ActiveRecord::Base.connection.execute("INSERT into `#{table}` (#{columns}) VALUES (#{row})")
#     end

#     line_num += 1
#   end
# end

# ###
# # Images
# ###
# ActiveRecord::Base.connection.execute("TRUNCATE images")
# columns = nil
# row = nil
# doc = REXML::Document.new(File.new(Rails.root.join("db", "paperclip", "data", "images.xml")))
# columns = "`id`, `created_at`, `updated_at`, `creator_id`, `status`, `original_image_url`, `cropped_image_url`, `crop_data`"

# # Cache the URLs in this format: {1: {original: "", cropped: ""}}
# urls = {}
# File.open(Rails.root.join("db", "paperclip", "data", "image_urls.csv")).read.each_line do |line|
#   parts = line.split(",")
#   urls[parts[0]] = {original: parts[1] || "", cropped: parts[2] || ""}
# end

# doc.root.elements["images"].select{|t| t.is_a?(REXML::Element)}.each do |row|
#   id = row.elements["id"].text

#   # We only need the drag part of the crop_data
#   if row.elements["crop_data"].text.length > 0
#     if drag = row.elements["crop_data"].text.split(":drag:")[1]
#       drag = drag.gsub(/(:)(\w)/, '\2').gsub(/"/, "'")
#       crop_data = "--- !ruby/hash:ActiveSupport::HashWithIndifferentAccess\ndrag: !ruby/hash:ActiveSupport::HashWithIndifferentAccess#{drag}"
#     else
#       crop_data = "NULL"
#     end
#   else
#     crop_data = "NULL"
#   end

#   # URLs
#   if urls[id]
#     original = urls[id][:original]
#     cropped = urls[id][:cropped]
#   else
#     original = ""
#     cropped = ""
#   end

#   # Data for the row
#   cells = [
#     id,
#     %Q('#{row.elements["created_at"].text}'),
#     %Q('#{row.elements["updated_at"].text}'),
#     row.elements["creator_id"].text,
#     row.elements["status"].text,
#     %Q("#{original}"),
#     %Q("#{cropped}"),
#     %Q("#{crop_data}")
#   ].join(", ")

#   puts "INSERT into `images` (#{columns}) VALUES (#{cells})"
#   ActiveRecord::Base.connection.execute("INSERT into `images` (#{columns}) VALUES (#{cells})")
# end

# # ###
# # # Stock Images
# # ###
# ActiveRecord::Base.connection.execute("TRUNCATE stock_images")
# columns = nil
# row = nil
# line_num = 0
# doc = REXML::Document.new(File.new(Rails.root.join("db", "paperclip", "data", "images.xml")))
# columns = "`id`, `title`, `status`, `created_at`, `updated_at`, `label`, `image_url`"

# # Cache the URLs in this format: {1: {url: ""}}
# urls = {}
# File.open(Rails.root.join("db", "paperclip", "data", "stock_image_urls.csv")).read.each_line do |line|
#   parts = line.split(",")
#   urls[parts[0]] = {image: parts[1]}
# end

# File.open(Rails.root.join("db", "paperclip", "data", "stock_images.csv")).read.each_line do |line|
#   if line_num > 0
#     row = line.encode('UTF-8', invalid: :replace).split(",")

#     if urls[row[0]]
#       image = urls[row[0]][:image]
#     else
#       image = ""
#     end

#     cells = [
#       row[0],
#       row[1],
#       row[6],
#       row[7],
#       row[8],
#       row[9],
#       %Q("#{image}"),
#     ].join(", ")
#     puts "INSERT into `stock_images` (#{columns}) VALUES (#{cells})"
#     ActiveRecord::Base.connection.execute("INSERT into `stock_images` (#{columns}) VALUES (#{cells})")
#   end

#   line_num += 1
# end


# ###
# # Documents
# ###
ActiveRecord::Base.connection.execute("TRUNCATE documents")
columns = nil
row = nil
doc = REXML::Document.new(File.new(Rails.root.join("db", "paperclip", "data", "documents.xml")))
columns = "`id`, `template_id`, `title`, `description`, `status`, `created_at`, `updated_at`, `tag_id`, `creator_id`, `crop_marks`, `pdf_url`, `thumbnail_url`, `share_graphic_url`, `generated`"

# Cache the URLs in this format: {1: {pdf: "", thumbnail: "", share_graphic: ""}}
urls = {}
File.open(Rails.root.join("db", "paperclip", "data", "document_urls.csv")).read.each_line do |line|
  parts = line.split(",")
  urls[parts[0]] = {pdf: parts[1] || "", thumbnail: parts[2] || "", share_graphic: parts[3] || ""}
end

doc.root.elements["documents"].select{|t| t.is_a?(REXML::Element)}.each do |row|
  id = row.elements["id"].text

  # URLs
  if urls[id]
    pdf = urls[id][:pdf]
    thumbnail = urls[id][:thumbnail]
    share_graphic = urls[id][:share_graphic]
  else
    pdf = ""
    thumbnail = ""
    share_graphic = ""
  end

  # Data for the row
  cells = [
    id,
    row.elements["template_id"].text,
    %Q("#{row.elements["title"].text}"),
    %Q("#{row.elements["description"].text}"),
    row.elements["template_id"].text,
    %Q('#{row.elements["created_at"].text}'),
    %Q('#{row.elements["updated_at"].text}'),
    row.elements["tag_id"].text,
    row.elements["creator_id"].text,
    row.elements["crop_marks"].text,
    %Q("#{pdf}"),
    %Q("#{thumbnail}"),
    %Q("#{share_graphic}"),
    0
  ].join(", ")

  puts "INSERT into `documents` (#{columns}) VALUES (#{cells})"
  ActiveRecord::Base.connection.execute("INSERT into `documents` (#{columns}) VALUES (#{cells})")
end

# ###
# # Templates
# ###
# ActiveRecord::Base.connection.execute("TRUNCATE templates")
# line_num = 0
# columns = nil
# row = nil
