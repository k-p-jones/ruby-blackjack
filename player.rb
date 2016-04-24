class Player
	attr_accessor :name, :hand, :bankroll
	def initialize(name)
		@name = name
		@hand = []
		@bankroll = 1000
	end
end
