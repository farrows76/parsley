Rails.application.routes.draw do
  get '/find/:id', to: 'items#find', defaults: { format: :json }, as: :find_item
  put '/update', to: 'items#update', defaults: { format: :json }, as: :item_update
  post '/create', to: 'items#create', defaults: { format: :json }, as: :item_create
  post '/upload', to: 'items#upload', defaults: { format: :json }, as: :upload_file
end
