# Run with: load Rails.root.join("db", "paperclip", "migrate.rb")
require "byebug"
# [
#   "affiliates", "ar_internal_metadata", "campaigns_templates", "campaigns_users", "campaigns",
#   "categories", "data", "documents_users", "images_users", "schema_migrations", "users"
# ].each do |table|
["data"].each do |table|
  ActiveRecord::Base.connection.execute("TRUNCATE #{table}")
  line_num = 0
  columns = nil
  row = nil

  File.open(Rails.root.join("db", "paperclip", "data", "#{table}.csv")).read.each_line do |line|
    if line_num == 0
      columns = line.gsub('"', '`')
    else
      row = line.encode('UTF-8', invalid: :replace)
      puts "INSERT into `#{table}` (#{columns}) VALUES (#{row})"
      ActiveRecord::Base.connection.execute("INSERT into `#{table}` (#{columns}) VALUES (#{row})")
    end

    line_num += 1
  end
end
