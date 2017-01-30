def controller_user_sign_in
  let!(:current_user) { FactoryGirl.create(:user) }
  User.current_user = current_user
  
  before(:each) do
    request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in current_user
  end
end
