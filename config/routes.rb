Rails.application.routes.draw do
  get 'users/new'
  # ヘルプページを作成する際はコメントを外す
# get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  get '/signup',  to: 'users#new'
  post '/signup', to: 'users#create'
  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
