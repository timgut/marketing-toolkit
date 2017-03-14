Rails.application.routes.draw do
  concern :trashable do
    collection do
      get :trashed
    end

    member do
      patch  :trash
      patch  :restore
    end
  end

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

  resources :campaigns, only: [:index, :show]
  resources :templates, only: [:index, :show]

  resources :documents, except: [:show], concerns: [:trashable] do
    collection do
      get :preview
      get :recent
      get :shared
    end

    member do
      get :duplicate
      get :download
      get :share
    end
  end
  
  resources :images, concerns: [:trashable] do
    collection do
      get :choose
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
    resources :campaigns, except: [:new, :show]
    resources :users do
    end
    resources :categories, except: [:new]
    resources :templates, except: [:show]
    resources :affiliates do
    end
  end
  
end
