TicTacRails::Application.routes.draw do

  resources :users, :only => [:create, :destroy]
  resources :games, :only => [:index, :create, :update, :show] do
    post 'winner'
  end

  post '/login'  => 'sessions#create'
  post '/logout' => 'sessions#destroy'

  root :to => 'games#index'
end
