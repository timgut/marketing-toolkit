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
    parent_id nil
  end

  factory :category do
    title "Flyer"
  end

  factory :creator, class: User do
    email
    affiliate
    
    password              "12345678"
    password_confirmation "12345678"
  end

  factory :datum do
    document

    key   "headline"
    value "We never quit on the people who depend on us."
  end

  factory :document do
    template
    creator

    title       "My Custom Document"
    description "My description for this document"
    status      "publish"
  end

  factory :image do
    image { File.new("#{Rails.root}/spec/support/images/landscape.jpg") }
    creator
  end

  factory :template do
    title       "Industry-Specific Document"
    description "A document for each industry AFSCME represents"
    height      11.0
    width       8.5
    pdf_markup  "<html><body>Hello World</body></html>"
    form_markup "This is a placeholder for the form markup."
    status      "publish"

    blank_image { File.new("#{Rails.root}/templates/Sector Specific/blank-ss.png") }

    campaign
    category
  end

  factory :user do
    email
    affiliate
    password "12345678"
    password_confirmation "12345678"
    approved true
  end

  factory :admin, class: User do
    email
    affiliate
    password "12345678"
    password_confirmation "12345678"
    approved true
    role "Administrator"
  end

  factory :document_user do
    document
    user
  end

  factory :image_user do
    image
    user
  end
end
