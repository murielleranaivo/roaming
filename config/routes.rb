Rails.application.routes.draw do
  get 'taps/index'

  root to: 'taps#index'
  get '/login', to: 'sessions#login'

  post '/upload', to: 'taps#upload'
  get '/decode', to: 'taps#decode'

  post '/sessions', to: 'sessions#create'

  get '/sign_out', to: 'sessions#destroy'

  get '/register', to: 'users#register'

  post '/users', to: 'users#create'

  get '/index', to: 'pages#index', as: 'index'

end
 