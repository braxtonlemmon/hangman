#/home/braxton/.rbenv/shims/ruby
require_relative 'board'
require_relative 'player'

class Game
	attr_accessor :player, :board, :answer, :mistakes, :correct, :incorrect
	
	def initialize
		@board = Board.new
		@answer = pick_word
		@mistakes = 3
		@correct = Array.new(answer.length)
		@incorrect = Array.new
		setup_game
	end

	def setup_game
		puts "Welcome to Hangman! Please enter your name: "
		@player = Player.new(gets.chomp)
		play_game
	end
	
	def pick_word
		words = {
			0 => "Zebra",
			1 => "Brain",
			2 => "Monkey", 
			3 => "Frisbee",
			4 => "Love",
			5 => "Inconsideration"
		}
		while true
			 word = words[rand(6)]
			 return word.upcase if word.length.between?(5,12)
		end
	end

	def play_game
		puts answer
		loop_turns
	end

	def loop_turns
		while mistakes < 6
			board.show(correct, incorrect, mistakes)
			eval_guess(make_guess)
		end
	end

	def make_guess
		while true
			puts "Please guess a letter:"
			letter = gets.chomp.upcase
			return letter if letter.length == 1 && letter.match?(/[A-Z]/)
		end
	end

	def eval_guess(make_guess)
		if answer.include?(make_guess)
			answer.length.times { |i| (@correct[i] = make_guess) if answer[i] == make_guess }
		else 
			@incorrect << make_guess
		end
	end
end

game = Game.new
