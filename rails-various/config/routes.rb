Rails.application.routes.draw do
  get 'orders' => 'orders#index'
  get 'orders/:id', to: 'orders#show', as: 'order'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
