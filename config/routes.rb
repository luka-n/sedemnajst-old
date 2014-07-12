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

  get "rankings" => "rankings#index"
  get "search" => "search#index"

  get "stats" => "stats#index"
  get "stats/pph" => "stats#pph"
  get "stats/ppdow" => "stats#ppdow"
  get "stats/pphod" => "stats#pphod"

  root "topics#index"
end
