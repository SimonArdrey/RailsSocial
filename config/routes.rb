Rails.application.routes.draw do
  resources :posts
  # devise_for :admin_users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  root "pages#show", page: "landing"
  get "/pages/:page" => "pages#show"

  devise_for :users, path: "/account"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
