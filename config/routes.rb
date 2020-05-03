Rails.application.routes.draw do
  get 'kombats/index', as: 'kombats'
  post 'kombats/fight', as: 'kombat'
  get 'kombats/form', as: 'kombat_form'
  root 'kombats#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
