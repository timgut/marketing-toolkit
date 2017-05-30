def controller_user_sign_in
  let!(:current_user) { FactoryGirl.create(:user) }
  
  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in current_user
  end
end

def controller_admin_sign_in
  let!(:current_user) { FactoryGirl.create(:admin) }
  
  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in current_user
  end
end