# Users
crumb :profile do |user|
  link 'My Profile', profile_path
end

crumb :edit_password do |user|
  link 'Change Password', password_path
  parent :profile
end

# Admin Users
crumb :admin_users do
  link "Manage Users", admin_users_path
  parent :admin
end

crumb :edit_user do |user|
  link user.name, edit_user_registration_path
  parent :admin_users
end
