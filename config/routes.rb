Rails.application.routes.draw do
  put '/update', to: 'items#update', as: :item_update
  post '/create', to: 'items#create', as: :item_create

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
