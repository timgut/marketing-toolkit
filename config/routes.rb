Rails.application.routes.draw do
  devise_for :users

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
    member do
      get :resize
    end
  end

  root to: "campaigns#index"
end
