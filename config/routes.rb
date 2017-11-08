Rails.application.routes.draw do
  # devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  root "pages#show", page: "landing"
  get "/pages/:page" => "pages#show"

  devise_for :users, path: "/account", controllers: { registrations: "users/registrations" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :posts, only: [:index, :show, :delete, :update]

  resources :users, path: "profiles", param: :slug, :constraints => { :slug => /[^\/]+/ } do
    resources :posts, controller: "users_posts"
  end
end
