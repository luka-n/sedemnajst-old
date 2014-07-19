Rails.application.routes.draw do
  resources :posts
  resources :topics

  resources :users do
    scope module: "users" do
      resources :posts
      resources :topics
    end
    get "pph", on: :member
    get "ppdow", on: :member
    get "pphod", on: :member
  end

  get "sessions/new" => "sessions#new", as: :new_session
  post "sessions" => "sessions#create", as: :sessions
  delete "user/session" => "sessions#destroy", as: :session

  get "passwords/new" => "passwords#new", as: :new_password
  post "passwords" => "passwords#create", as: :passwords
  get "user/password/edit" => "passwords#edit", as: :edit_password
  put "user/password" => "passwords#update", as: :password
  patch "user/password" => "passwords#update"

  get "rankings" => "rankings#index"
  get "search" => "search#index"

  get "stats" => "stats#index"
  get "stats/pph" => "stats#pph"
  get "stats/ppdow" => "stats#ppdow"
  get "stats/pphod" => "stats#pphod"

  root "topics#index"
end
