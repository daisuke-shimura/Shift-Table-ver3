Rails.application.routes.draw do

  devise_for :users
  root to: 'homes#top'

  resources :users, only: [:index, :show, :edit]
  resources :jobs, only: [:new, :create, :update, :destroy, :index, :show, :edit] do
    resources :job_comments, only: [:create, :destroy]
  end


end
