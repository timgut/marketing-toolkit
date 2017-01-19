FactoryGirl.define do
  # HELPERS
  sequence :email do |n|
    "person#{n}@example.com"
  end

  # MODELS
  factory :campaign do
    title "Never Quit"
    description "This is the Never Quit campaign"
  end

  factory :datum do
    flyer
    key "headline"
    value "We never quit on the people who depend on us."
  end

  factory :flyer do
    template
    title "My Custom Flyer"
    description "My description for this flyer"
  end

  factory :image do

  end

  factory :template do
    title "Industry-Specific Flyer"
    description "A flyer for each industry AFSCME represents"
    height 11
    width 8.5
  end

  factory :user do
    email
    password "12345678"
    password_confirmation "12345678"
  end

  # JOIN TABLES
  factory :campaign_flyer do
    campaign
    flyer
  end

  factory :flyer_user do
    flyer
    user
  end

  factory :image_user do
    image
    user
  end
end
