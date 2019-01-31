Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/welcome' => 'welcome#index'

  resources :games

  root to: 'welcome#index'

  get "/auth/google_login/callback" => "sessions#create"
  get "/signout" => "sessions#destroy", :as => :signout
end
