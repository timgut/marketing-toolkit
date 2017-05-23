FactoryGirl.define do
  # HELPERS
  sequence :email do |n|
    "person#{n}@example.com"
  end

  # MODELS
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

    blank_image { File.new("#{Rails.root}/templates/Industry Specific/blank-ss.png") }

    blank_image_height 761
    blank_image_width  600
    
    crop_top    148
    crop_bottom 705
  end

  factory :user do
    email
    password "12345678"
    password_confirmation "12345678"
  end

  # JOIN TABLES
  factory :campaign_document do
    campaign
    document
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
