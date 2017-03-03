Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "users/registrations"}

  devise_scope :user do
    get 'confirmation', to: 'users/registrations#confirmation'
    get 'applications', to: 'users/registrations#applications'
    authenticated :user do
      root 'campaigns#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end

    get 'profile', to: 'users/registrations#edit'
    put 'profile', to: 'home#update'

  end

  resources :campaigns
  resources :templates

  resources :documents do
    collection do
      get :preview
    end

    member do
      get :generate
    end
  end
  
  resources :images do
    collection do
      get :recent
      get :shared
    end

    member do
      get :resize
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
