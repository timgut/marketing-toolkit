# Run with: load Rails.root.join("db", "paperclip", "migrate.rb")
# require "byebug"
require "rexml/document"
include REXML

###
# Tables to migrate as-is
###
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

###
# Images
###
ActiveRecord::Base.connection.execute("TRUNCATE images")
line_num = 0
columns = nil
row = nil
doc = REXML::Document.new(File.new(Rails.root.join("db", "paperclip", "data", "images.xml")))
columns = "`id`, `created_at`, `updated_at`, `creator_id`, `status`, `original_image_url`, `cropped_image_url`, `crop_data`"
doc.root.elements["images"].select{|t| t.is_a?(REXML::Element)}.each do |row|
  cells = [
    row.elements["id"].text,
    row.elements["created_at"].text},
    row.elements["updated_at"].text},
    row.elements["status"].text},
  ].join(", ")

  puts "INSERT into `images` (#{columns}) VALUES (#{cells})"
  ActiveRecord::Base.connection.execute("INSERT into `images` (#{columns}) VALUES (#{cells})")
end

puts doc.elements.inspect
binding.irb
#   if line_num == 0
#     columns = line.gsub('"', '`')
#   else
#     # row = line.encode('UTF-8', invalid: :replace)
#     # puts "INSERT into `#{table}` (#{columns}) VALUES (#{row})"
#     # ActiveRecord::Base.connection.execute("INSERT into `#{table}` (#{columns}) VALUES (#{row})")
#   end

#   line_num += 1
# end

# ###
# # Stock Images
# ###
# ActiveRecord::Base.connection.execute("TRUNCATE stock_images")
# line_num = 0
# columns = nil
# row = nil

# ###
# # Documents
# ###
# ActiveRecord::Base.connection.execute("TRUNCATE documents")
# line_num = 0
# columns = nil
# row = nil

# ###
# # Stock Templates
# ###
# ActiveRecord::Base.connection.execute("TRUNCATE templates")
# line_num = 0
# columns = nil
# row = nil
