PracticeApp::Application.routes.draw do

  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  
  resources :invitations
  resources :messages
  resources :activities
  resources :sessions
  resources :password_resets

  resources :users do
    resources :comments
    resources :events
    resources :relationships
  end

  resources :events do
    resources :comments
  end

  get '/contact_us', to: 'welcome#contact_us'
  root to: 'welcome#index'
end