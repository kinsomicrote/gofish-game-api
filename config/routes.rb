Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :games, only: %i[create] do
        resources :players, only: %i[show], param: :playerName do
          post :fish, on: :member
        end
      end
    end
  end
end
