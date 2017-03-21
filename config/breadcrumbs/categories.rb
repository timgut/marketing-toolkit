# Categories
crumb :category do |category|
  link category.title, templates_path
  parent :templates
end

# Admin Categories
crumb :admin_edit_category do |category|
  link "Edit #{category.title}", edit_admin_category_path(category)
  parent :admin_categories
end

crumb :admin_categories do
  link "Categories", admin_categories_path
  parent :admin
end
