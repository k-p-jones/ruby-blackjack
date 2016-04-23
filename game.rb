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

	def get_player
		@player = Player.new("")
		puts "Please enter your name...."
		@player.name = gets.chomp.to_s
	end

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

	def announce_dealer_hand
		d_hand = @dealer.hand.first
		puts "The dealer is showing"
		puts "#{d_hand.rank} #{d_hand.suit}"
		puts " "
	end

	def announce_full_dealer_hand
		puts "The dealer is showing"
		@dealer.hand.each do |card|
			puts"#{card.rank} #{card.suit}"
		end
	end

	def announce_player_hand
		puts "You have been dealt:"
		@player.hand.each do |card|
			puts "#{card.rank} #{card.suit}"
		end
	end

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
	end

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
	end

	def player_hit
		@player.hand << @cards.deck.shift
	end

	def dealer_hit
		@dealer.hand << @cards.deck.shift
	end

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

	def player_turn
		while @player_score < 22
			if stick_or_twist == "s"
				break
			end
		end
	end

	def dealer_turn
		if @player_score > 21
			puts "You are bust, dealer wins the hand!"
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

	def result
		if @player_score >21
			puts "Dealer wins"
		elsif @player_score < 21 && @dealer_score > 21
			puts "Player wins"
		elsif @player_score > 21 && @dealer_score < 21
			puts "Dealer wins!"
		elsif (@dealer_score > @player_score) && (@dealer_score <22) && (@player_score && @dealer_score <22)
			puts "Dealer wins"
		elsif (@player_score > @dealer_score) && (@player_score < 22) && (@dealer_score && @player_score < 22)
			puts "Player wins!"
		elsif 
			(@player_score == @dealer_score) && (@player_score < 22) && (@dealer_score && @player_score < 22)
			pus "Hand is a draw"
		end
	end

	def test
		@cards.shuffle_cards
		deal_cards
		announce_dealer_hand
		announce_player_hand
		get_player_score
		player_turn
		dealer_turn
		result
	end
end

a = Game.new
a.test