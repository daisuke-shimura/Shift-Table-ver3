Rails.application.routes.draw do

  devise_for :users
  root to: 'homes#top'

  resources :users, only: [:index, :show, :edit, :update, :destroy]
  resources :days, only: [:index, :show, :create, :destroy] do
    resources :jobs, only: [:new, :create, :update, :destroy, :edit] do
      resources :job_comments, only: [:create, :destroy]
    end
  end
  get "past" => 'days#index2'

end
