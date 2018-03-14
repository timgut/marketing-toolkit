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

  get 'intro', to: 'misc#intro', as: :intro

  devise_for :users, controllers: {registrations: "users/registrations"}

  devise_scope :user do
    get 'password',        to: 'users/registrations#password'
    put 'update_password', to: 'users/registrations#update_password'
    get 'confirmation',    to: 'users/registrations#confirmation'
    get 'applications',    to: 'users/registrations#applications'

    authenticated :user do
      root 'misc#intro', as: :authenticated_root
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
      get :recent
      get :shared
    end

    member do
      get :duplicate
      get :download
      get :job_status, defaults: {format: :json}
      get :preview
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
      get :contextual_crop
      get :papercrop
      get :share
    end
  end

  namespace :admin, path: '/admin' do
    root to: "misc#home"

    resources :templates, except: [:show] do
      collection do
        get   :positions
        patch :update_positions
      end
    end

    resources :users, except: [:destroy, :show] do
      get :workspace

    resources :campaigns,  except: [:new, :show] do
      member do
        put :whitelist
        put :blacklist
      end
    end

    get 'documentation', to: 'misc#documentation', as: :documentation
    get 'stats', to: 'misc#stats', as: :stats

    resources :campaigns,  except: [:new, :show]
    resources :users,      except: [:destroy, :show]
    resources :categories, except: [:new, :show]
    resources :affiliates, only:   []
  end
end
