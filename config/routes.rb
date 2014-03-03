Think200::Application.routes.draw do
  post "ajax/queue_status"
  resources :spec_runs

  resources :expectations

  resources :matchers

  resources :requirements

  resources :apps, except: [:index, :show]

  resources :projects do
    get 'export'
  end

  root "pages#home"    
  get "home", to: "pages#home", as: "home"
  get "inside", to: "pages#inside", as: "inside"
  
    
  devise_for :users
  
  namespace :admin do
    root "base#index"
    resources :users
  end

  post 'retest_project/:id', to: 'projects#retest', as: 'retest_project'


  # Resque ######################

  ResqueWeb::Engine.eager_load!

  resque_constraint = lambda do |request|
    request.env['warden'].authenticate? and request.env['warden'].user.admin?
  end

  constraints resque_constraint do
    # mount Resque::Server, :at => "/admin/resque"
    mount ResqueWeb::Engine => "/resque"
  end
end
