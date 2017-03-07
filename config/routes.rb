Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "users/registrations"}

  devise_scope :user do
    get 'password', to: 'users/registrations#password'
    put 'update_password', to: 'users/registrations#update_password'
    get 'confirmation', to: 'users/registrations#confirmation'
    get 'applications', to: 'users/registrations#applications'
    authenticated :user do
      root 'campaigns#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end

    get 'profile', to: 'users/registrations#edit'
  end

  resources :campaigns
  resources :templates

  resources :documents do
    collection do
      get :preview
      get :recent
      get :shared
      get :trash
    end

    member do
      get :duplicate
      get :download
      get :share
    end
  end
  
  resources :images do
    collection do
      get :recent
      get :shared
    end

    member do
      get :resize
      get :share
    end
  end

  namespace :admin, path: '/admin' do
    root to: "users#home"
    resources :campaigns do
    end
    resources :users do
    end
    resources :categories do
    end
  end
  
end
