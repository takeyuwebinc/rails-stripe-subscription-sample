Rails.application.routes.draw do
  root "home#index"
  resource :session, only: [:new, :create]
  resources :invoices, only: [:index, :show]
  post "webhook/stripe"
end
