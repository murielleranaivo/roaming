Rails.application.routes.draw do 
  
  root to: 'sessions#login'
  get '/login', to: 'sessions#login'

  post '/sessions', to: 'sessions#create'

  get '/sign_out', to: 'sessions#destroy'

  get '/register', to: 'users#register'

  post '/users', to: 'users#create'
  
  get '/index', to: 'pages#index', as: 'index'


end
 