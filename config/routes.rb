Rails.application.routes.draw do
  get 'taps/index'

  root to: 'taps#index'
  get '/login', to: 'sessions#login'

  post '/upload', to: 'taps#upload'
  get '/decode/:id', to: 'taps#decode'
  get '/download/:id', to: 'taps#receipt', as: 'download_file'

  post '/sessions', to: 'sessions#create'

  get '/sign_out', to: 'sessions#destroy'

  get '/register', to: 'users#register'

  post '/users', to: 'users#create'

  get '/index', to: 'pages#index', as: 'index'

end
 