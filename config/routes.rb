Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'welcomes#index'

  get '/books', to: 'books#index'
  get '/books/new', to: 'books#new', as: :new_book
  get '/books/:id', to: 'books#show', as: :book
  post '/books', to: 'books#create'
  delete '/books/:id', to: 'books#destroy'

  post '/books/:book_id/reviews', to: 'reviews#create', as: :book_reviews
  get '/books/:book_id/reviews/new', to: 'reviews#new', as: :new_book_review

  get 'authors/:id', to: 'authors#show', as: :author
  delete 'authors/:id', to: 'authors#destroy'

  get '/reviews/new', to: 'reviews#new'
  post '/reviews', to: 'reviews#create'
  delete '/reviews/:id', to: 'reviews#destroy', as: :review

  get 'users/:id', to: 'users#show', as: :user
end
