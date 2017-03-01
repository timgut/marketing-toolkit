Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "users/registrations"}

  devise_scope :user do
    get 'confirmation', to: 'users/registrations#show'
    get 'applications', to: 'users/registrations#applications'
    authenticated :user do
      root 'campaigns#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :campaigns do
    resources :templates do
      resources :flyers, except: [:index] do
        collection do
          get :preview
        end

        member do
          get :generate
        end
      end
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

  resources :flyers, only: [:index]

  namespace :admin, path: '/admin' do
    #root to: "users/index"
    resources :users do
    end
  end
  
end
