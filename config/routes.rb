Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  root "profiles#index"

  resources :profiles do
    member do
      post :rescan
    end
  end

   get "/:short_code", to: "profiles#redirect", as: :shortened
end
