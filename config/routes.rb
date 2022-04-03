Rails.application.routes.draw do

  devise_for :admins, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  root to: "public/homes#top"
  get '/about' => 'public/homes#about', as: 'about'
  namespace :public do

  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
