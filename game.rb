require './dealer.rb'
require './player.rb'
require './cards_and_deck.rb'

class Game
	attr_accessor :rank, :suit, :hand
	def initialize
		get_player
		@cards = Deck.new
		@dealer = Dealer.new
	end
	#gets the players name
	def get_player
		@player = Player.new("")
		puts "Please enter your name...."
		@player.name = gets.chomp.to_s
	end
	#deals hands
	def deal_cards
		puts " "
		puts "Dealing cards..."
		puts " "
		2.times do 
			@dealer.hand << @cards.deck.shift
		end
		2.times do 
			@player.hand << @cards.deck.shift
		end
	end
	#declares one card of the dealers hand
	def announce_dealer_hand
		d_hand = @dealer.hand.first
		puts "The dealer is showing"
		puts "#{d_hand.rank} #{d_hand.suit}"
		puts " "
	end
	#declares full dealer hand
	def announce_full_dealer_hand
		puts "The dealer is showing"
		@dealer.hand.each do |card|
			puts"#{card.rank} #{card.suit}"
		end
	end
	#declares full player hand
	def announce_player_hand
		puts "You have been dealt:"
		@player.hand.each do |card|
			puts "#{card.rank} #{card.suit}"
		end
	end
	#gets a players score, possible refactor, do I really need two methods for this?
	def get_player_score
		@player_score = 0
		faces = %w(J Q K A)
		ranks = %W(2 3 4 5 6 7 8 9 10)
		@player.hand.each do |card|
			if ranks.include?(card.rank)
				score = card.rank.to_i
				@player_score += score
			elsif faces.include?(card.rank)
				if card.rank == "A"
					@player_score += 11
				else
					@player_score += 10
				end
			end
		end
		puts " "
		puts "Score: #{@player_score}"
		puts " "
	end
	#gets the score, possible refactor, do I really need two methods for this?
	def get_dealer_score
		@dealer_score = 0
		faces = %w(J Q K A)
		ranks = %W(2 3 4 5 6 7 8 9 10)
		@dealer.hand.each do |card|
			if ranks.include?(card.rank)
				score = card.rank.to_i
				@dealer_score += score
			elsif faces.include?(card.rank)
				if card.rank == "A"
					@dealer_score += 11
				else
					@dealer_score += 10
				end
			end
		end
		puts " "
		puts "Score: #{@dealer_score}"
		puts " "
	end
	#shift cards from deck to a players hand
	def player_hit
		@player.hand << @cards.deck.shift
	end
	#shift cards from the deck to the dealers hand
	def dealer_hit
		@dealer.hand << @cards.deck.shift
	end
	#method for player action, possible refactor? It's a bit ugly
	def stick_or_twist
		puts "Stick(s) or twist(t)?"
		choice = gets.chomp.to_s.downcase
		unless choice == "s" || choice == "t"
			puts "Stick(s) or twist(t)?"
			choice = gets.chomp.to_s.downcase
		end
		if choice == "s"
			get_player_score
			return "s"
		else
			player_hit
			announce_player_hand
			get_player_score
		end
	end
	#loop for player turn
	def player_turn
		puts "You have £#{@player.bankroll}"
		while @player_score < 22
			if stick_or_twist == "s"
				break
			end
		end
	end
	#sets player wager. Sets itself to zero every time it is called
	def player_bet
		puts "You have £#{@player.bankroll}"
		puts "Dealer has £#{@dealer.bankroll}"
		@player_wager = 0
		until @player_wager > 0 && @player_wager <= @player.bankroll
			puts "Place your bets please"
			@player_wager = gets.chomp.to_i
		end
		puts " "
		puts "#{@player.name} bets £#{@player_wager}"
		@player.bankroll -= @player_wager
	end
	#dealer turn, checks if player is bust before acting
	def dealer_turn
		if @player_score > 21
			puts "You are bust!"
		else
			announce_full_dealer_hand
			get_dealer_score
			while @dealer_score < 17
				puts "Dealer hits."
				dealer_hit
				announce_full_dealer_hand
				get_dealer_score
			end
			if @dealer_score > 21
				puts "Dealer is bust!"
			else
				puts "Dealer stands."
			end
		end
	end
	#determin winner and adjust bankrolls accordingly
	def result
		if @player_score >21
			puts "Dealer wins"
			@dealer.bankroll += @player_wager
		elsif @player_score < 21 && @dealer_score > 21
			puts "Player wins"
			@player.bankroll += @player_wager * 2
			@dealer.bankroll -= @player_wager
		elsif (@dealer_score > @player_score) && (@dealer_score <22) && (@player_score && @dealer_score <22)
			puts "Dealer wins"
			@dealer.bankroll += @player_wager
		elsif (@player_score > @dealer_score) && (@player_score < 22) && (@dealer_score && @player_score < 22)
			puts "Player wins!"
			@player.bankroll += @player_wager * 2
			@dealer.bankroll -= @player_wager
		elsif 
			(@player_score == @dealer_score) && (@player_score < 22) && (@dealer_score && @player_score < 22)
			puts "Hand is a draw"
			@player.bankroll += @player_wager
		end
	end
	#reset the deck
	def reset
		@player.hand.each do |card|
			@cards.deck << card
		end
		@player.hand.replace([])
		@dealer.hand.each do |card|
			@cards.deck << card
		end
		@dealer.hand.replace([])
	end
	#main game loop
	def play
		until @player.bankroll == 0 || @dealer.bankroll <= 0
			@cards.shuffle_cards
			player_bet
			deal_cards
			announce_dealer_hand
			announce_player_hand
			get_player_score
			player_turn
			dealer_turn
			result
			reset
		end
		if @dealer.bankroll <= 0 
			puts "CONGRATULATIONS!! You have won the game!"
		else
			puts "Better luck next time, the dealer took all your cash!"
		end
	end
end

a = Game.new
a.play