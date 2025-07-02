Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # resources :instruments, only: [:index, :show, :new, :create] # plus besoin de cette ligne car
  # bloc resources :instruments do ... end gère déjà toutes les routes pour instruments
  # et permet de nester bookings proprement

  resources :instruments do
    resources :bookings, only: %i[new create]
    resources :reviews, only: [:create]
  end
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get 'dashboard', to: 'instruments#dashboard', as: :dashboard

  # Defines the root path route ("/")
  # root "posts#index"
end
