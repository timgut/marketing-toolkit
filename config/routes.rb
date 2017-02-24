Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'campaigns#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  resources :campaigns do
    resources :templates do
      resources :flyers do
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
      get :choose
      get :recent
      get :shared
    end

    member do
      get :resize
    end
  end

end
