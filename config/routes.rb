Rails.application.routes.draw do
  devise_for :users

  resources :campaigns

  resources :flyers do
    collection do
      get :preview
    end

    member do
      get :generate
    end
  end
  
  resources :images do
    member do
      get :resize
    end
  end

  resources :templates

  root to: "campaigns#index"
end
