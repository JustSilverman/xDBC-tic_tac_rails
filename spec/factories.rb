FactoryGirl.define do
  factory :user, :aliases => [:player1, :player2, :winner, :active_player] do
    sequence(:username) {|n| "John#{n}" }
    sequence(:email)    {|n| "user#{n}@example.com" }
    password                 "password"
    password_confirmation    "password"
  end

  factory :game do 
    board     { Array.new(9) { ["O", "X", "-"].sample}.join("") }
    player1    
    player2
    after(:build) do |game| 
      game.active_player = game.player1
    end
  end

  factory :game_with_winner, :parent => :game do 
    after(:create) do |game|
      game.winner = game.active_player
    end
  end
end
