Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "tops#index"
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms_of_service', to: 'static_pages#terms_of_service'
  resources :tops, only: [:index]
  resources :users, only: [:new, :create]
  resources :password_resets, only: [:new, :create, :edit, :update]

  namespace :smoker do
    resources :graphs, only: [:index]

    resources :cigarettes, only: [:index, :create, :edit, :update] do
      collection do
        get :brands
      end
    end

    resources :smoking_records, only: [:index, :create, :destroy]
  end

  namespace :non_smoker do
    resources :quit_smoking_records, only: [:index, :create, :update] do
      get 'logs', on: :collection
    end
    resources :savings_goals, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  get 'login', to: 'user_sessions#new', as: :login
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy', as: :logout
  post "oauth/callback" => "oauths#callback"
  get "oauth/callback" => "oauths#callback"
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider

  # Defines the root path route ("/")
  # root "posts#index"
end
