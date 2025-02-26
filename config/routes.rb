Rails.application.routes.draw do
  root "posts#index"
  resources :posts, only: [:new, :create, :show, :edit, :update]
end
