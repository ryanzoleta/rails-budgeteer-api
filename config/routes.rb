Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :account_types
  resources :accounts
  resources :transactions
  resources :categories
  resources :budgets
end
