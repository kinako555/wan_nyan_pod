Rails.application.routes.draw do
  root   'users#home'
  # ヘルプページを作成する際はコメントを外す
# get    '/help',   to: 'static_pages#help'
  get    '/about',  to: 'static_pages#about'
  get    '/signup', to: 'users#new'
  post   '/signup', to: 'users#create'
  post   '/search', to: 'users#search'
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get    'password_resets/new'
  get    'password_resets/edit'
  resources :users do
    # 例: users/1/following
    member do
      get :activate, :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships,       only: [:create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
