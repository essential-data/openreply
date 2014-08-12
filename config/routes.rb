Openreply::Application.routes.draw do
  devise_for :users

  root 'dashboard#wall'

  resources :ratings, only: [:create, :index] do
    resources :reviews, only: [:new, :edit]
    post 'reviews' => 'reviews#update'
    resource :reviews, only: [:update]
  end

  # get 'ratings', to: 'ratings#index'
  get 'ratings/new', to: 'ratings#new_from_personal_details'
  get 'ratings/new/:ticket_id/:hash/:lang', to: 'ratings#new_validated_by_hash'
  get 'ratings/new/:ticket_id/:hash', to: 'ratings#new_validated_by_hash'
  get 'ratings/related_employees', to: 'ratings#related_employees'
  get 'ratings/related_customers', to: 'ratings#related_customers'

  get "graphs/bar"
  get "graphs/histogram"
  get "graphs/time_line"
  get "graphs/detailed_statistics"

  get "dashboard/wall"
  get "dashboard/employees_list"
  get "dashboard/customers_list"
end
