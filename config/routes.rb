Rails.application.routes.draw do
  put '/update', to: 'items#update', as: :item_update
  post '/create', to: 'items#create', as: :item_create
  post '/upload', to: 'items#upload', as: :upload_file
end
