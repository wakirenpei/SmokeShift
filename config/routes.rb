Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "tops#index"
  resources :tops, only: [:index]
  resources :users, only: [:new, :create]

  namespace :smoker do
    resources :cigarettes, only: [:index, :create, :edit, :update]
    resources :smoking_records, only: [:index, :create, :destroy]
  end

  namespace :non_smoker do
    resources :quit_smoking_records, only: [:index, :create, :update]
  end

  get 'login', to: 'user_sessions#new', as: :login
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy', as: :logout

  # Defines the root path route ("/")
  # root "posts#index"
end
