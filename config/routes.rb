TicTacRails::Application.routes.draw do

  resources :users, :only => [:create, :destroy, :show]
  resources :games, :only => [:index, :create, :update, :show] do
    post 'winner'
    post 'moves'
  end

  post '/login'  => 'sessions#login'
  post '/logout' => 'sessions#logout'

  root :to => 'games#index'
end
