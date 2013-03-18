module UsersHelper

	def wins
		current_user.games_won || 0
	end

	def losses
		current_user.games_lost || 0
	end

	def ties
		current_user.games_tied || 0
	end
end
