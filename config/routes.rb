TicTacRails::Application.routes.draw do

  resources :games, :only => [:index, :create, :update, :show] do
    post 'moves'
    post 'winner'
    post 'status'
  end

  resources :users, :only  do
    member do
      post 'logout'
      post 'login'
    end
  end

end
