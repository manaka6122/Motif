Rails.application.routes.draw do

  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: 'admin/sessions'
  }
  namespace :admin do
    resources :customers, only: [:index, :show]
    resources :activities, only: [:index, :show, :edit, :destroy]
    resources :teams, only: [:index, :show]
  end
  devise_for :customers, skip: [:passwords], controllers: {
    registrations: 'public/registrations',
    sessions: 'public/sessions'
  }
  root to: 'public/homes#top'
  get '/about' => 'public/homes#about', as: 'about'
  scope module: :public do
    get 'customers/show' => 'customers#show', as: 'customerpage'
    get 'customers/information/edit' => 'customers#edit', as: 'edit_information'
    patch 'customers/information' => 'customers#update', as: 'update_information'
    resources :activities do
      resource :favorites, only: [:create, :destroy]
    end
    resources :teams, only: [:new, :create, :index, :show, :edit, :update, :destroy]
    resources :room, only: [:index, :show]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
