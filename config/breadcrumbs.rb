# Breadcrumbs won't display without a parent. This is a fake parent that's hidden.
crumb :root do
  link "", "#"
end

# Admin
crumb :admin do 
  link "Admin", admin_root_path
end

crumb :admin_stats do 
  link "Statistics", admin_stats_path
  parent :admin
end
