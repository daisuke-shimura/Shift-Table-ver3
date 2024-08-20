Rails.application.routes.draw do

  devise_for :users
  root to: 'homes#top'

  resources :users, only: [:show, :edit]
  resources :jobs, only: [:new, :create, :update, :destroy, :index, :show, :edit]


end
