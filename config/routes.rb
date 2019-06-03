Rails.application.routes.draw do
  # ヘルプページを作成する際はコメントを外す
# get    '/help',   to: 'static_pages#help'
  get    '/about',  to: 'static_pages#about'
  get    '/signup', to: 'users#new'
  post   '/signup', to: 'users#create'
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
