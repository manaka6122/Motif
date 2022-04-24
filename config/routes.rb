Rails.application.routes.draw do

  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }

  namespace :admin do
    resources :customers, only: [:index, :show]
    resources :activities, only: [:index, :show, :edit, :update, :destroy]
    resources :teams, only: [:index, :show, :edit, :update, :destroy]
  end

  devise_for :customers, skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }

  devise_scope :customer do
    post 'customers/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end

  root to: 'public/homes#top'
  get '/about' => 'public/homes#about', as: 'about'

  scope module: :public do
    resources :customers, only: [:show, :edit, :update] do
      member do
        get :favorites
      end
    end
    resources :activities do
      resource :favorites, only: [:create, :destroy]
    end
    resources :teams, only: [:new, :create, :index, :show, :edit, :update, :destroy]
    resources :rooms, only: [:index]
    resources :messages, only: [:show, :create]
    get '/search', to: 'searches#search'
    resources :notifications, only: [:index, :destroy]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
