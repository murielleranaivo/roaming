Rails.application.routes.draw do 
  
  root to: 'pages#home'

  get '/decode', to: 'pages#decode'
end
 