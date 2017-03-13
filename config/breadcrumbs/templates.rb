# Templates
crumb :templates do
  link "Templates", templates_path
  parent :root
end

crumb :template do |template|
  link template.title, template_path(template)
  parent :templates
end

# Admin Templates
crumb :admin_templates do
  link "Manage Templates", admin_templates_path
  parent :admin
end

crumb :admin_new_template do
  link "New Template", new_admin_template_path
  parent :admin_templates
end

crumb :admin_edit_template do |template|
  link template.title, edit_admin_template_path(template)
  parent :admin_templates
end
