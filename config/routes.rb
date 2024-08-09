Rails.application.routes.draw do

  devise_for :users
  root to: 'homes#top'

  resources :jobs, only: [:new, :index, :show, :edit]
  resources :users, only: [:show, :edit]

end
