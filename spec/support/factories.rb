FactoryGirl.define do
  # HELPERS
  sequence :email do |n|
    "person#{n}@example.com"
  end

  # MODELS
  factory :affiliate do
    title  "International Union"
    slug   "IU"
    state  "N/A"
    region "N/A"
  end

  factory :campaign do
    title "Never Quit"
    description "This is the Never Quit campaign"
    status "publish"
  end

  factory :datum do
    document
    key "headline"
    value "We never quit on the people who depend on us."
  end

  factory :document do
    template
    creator
    title "My Custom Document"
    description "My description for this document"
    status "publish"
  end

  factory :image do
    image { File.new("#{Rails.root}/spec/support/images/1260x573.jpg") }
  end

  factory :template do
    title "Industry-Specific Document"
    description "A document for each industry AFSCME represents"
    height 11
    width 8.5
    pdf_markup "<html><body>Hello World</body></html>"
    form_markup "This is a placeholder for the form markup."
    status "publish"

    blank_image { File.new("#{Rails.root}/templates/Sector Specific/blank-ss.png") }
  end

  # USERS
  factory :user do
    email
    affiliate
    password "12345678"
    password_confirmation "12345678"
    approved true
    role "User"
  end

  factory :admin, class: User do
    email
    affiliate
    password "12345678"
    password_confirmation "12345678"
    approved true
    role "Administrator"
  end

  factory :vetter, class: User do
    email
    affiliate
    password "12345678"
    password_confirmation "12345678"
    approved true
    role "Vetter"
  end

  factory :creator, class: User do
    email
    affiliate
    
    password              "12345678"
    password_confirmation "12345678"
  end

  # JOIN TABLES
  factory :document_user do
    document
    user
  end

  factory :image_user do
    image
    user
  end
end
