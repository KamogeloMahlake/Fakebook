Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "registrations", omniauth_callbacks: "users/omniauth_callbacks" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  resources :posts do
    resources :likes, only: [ :create, :destroy ]
    resources :comments
  end


  root "posts#index"

  get "browse", to: "posts#browse", as: :browse_posts

  get ":user_name", to: "profiles#show", as: :profile
  get ":user_name/edit", to: "profiles#edit", as: :edit_profile
  patch ":user_name/edit", to: "profiles#update", as: :update_profile

  post ":user_name/follow_user", to: "relationships#follow_user", as: :follow_user
  post ":user_name/unfollow_user", to: "relationships#unfollow_user", as: :unfollow_user
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
