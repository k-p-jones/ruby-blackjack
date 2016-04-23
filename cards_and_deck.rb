class Card
	attr_accessor :rank, :suit
	def initialize(rank, suit)
		@rank = rank
		@suit = suit
	end
end
#generate a full deck of cards
class Deck
	attr_accessor :deck, :hand
	def initialize
		@deck = []
		faces = %w(J Q K A)
		ranks = %W(2 3 4 5 6 7 8 9 10)
		suits = %w(Hearts Spades Diamonds Clubs)
		suits.each do |suit|
			ranks.each do |i|
				@deck << Card.new(i, suit)
			end
			faces.each do |i|
				@deck << Card.new(i, suit)
			end
		end
	end
	#returns the current state of the deck
	def print_deck
		@deck.each do |card| 
			puts "#{card.rank} #{card.suit}"
		end
	end
	#shuffles deck
	def shuffle_cards
		@deck.shuffle!
	end
end