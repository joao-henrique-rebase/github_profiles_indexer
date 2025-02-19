Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  resources :profiles do
    member do
      post :rescan
    end
  end
  root "profiles#index"
end
