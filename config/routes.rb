Rails.application.routes.draw do
  devise_for :users

  resources :flyers do
    collection do
      get :preview
    end

    member do
      get :generate
    end
  end

  resources :templates
end
