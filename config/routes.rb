Rails.application.routes.draw do

  devise_for :users
  root to: 'homes#top'

  resources :jobs, only: [:new, :create, :index, :show, :edit]
  resources :users, only: [:show, :edit]

end
