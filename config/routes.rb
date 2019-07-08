Rails.application.routes.draw do
  root "home#index"
  resource :session, only: [:new, :create]
end
