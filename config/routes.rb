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

  resources :folders
  resources :images
  resources :templates

  resources :image_folders, controller: 'folders'
  resources :flyer_folders, controller: 'folders'

  root to: "dashboard#index"
end
