#/home/braxton/.rbenv/shims/ruby
require_relative 'player'
require 'yaml'

class Game
	attr_accessor :player, :answer, :mistakes, :correct, :incorrect, :word_set, :filename
	
	def initialize
		@filename = nil
		@word_set = Array.new
		@answer = pick_a_word.split("")
		@mistakes = 0
		@correct = Array.new(answer.length) { "_" }
		@incorrect = Array.new
		setup_game
	end

	def setup_game
		puts "Welcome to Hangman! Please enter your name:"
		@player = Player.new(gets.chomp)
		puts "Would you like to load a saved game?"
		load_game if gets.chomp.downcase[0] == 'y'
		play_game
	end
	
	def pick_a_word
		File.readlines("words.txt").each do |word|
			word.rstrip!.length.between?(5,12) ? (@word_set << word.upcase) : next
		end
		@word_set[rand(word_set.length)]
	end

	def show_board
		puts "\n* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
		puts "*\tIncorrect guesses:   [ #{incorrect.join(" | ")} ]"
		puts "*"
		puts "*\tSo far:              [ #{correct.join(" | ")} ]"
		wrong = (1..8).map { |i| i <= mistakes ? "X" : "o" }
		puts "*"
		puts "*\tMistakes:            [ #{wrong.join(" | ")} ]"
		puts "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *"
	end

	def play_game
		show_board
		loop_turns
		finish_game
	end

	def loop_turns
		while mistakes < 8
			@mistakes += 1 unless right_letter?(make_guess)
			show_board
		  finish_game if win?
		end
	end

	def make_guess
		while true
			puts "Please guess a letter or press (1) to save and exit game:"
			letter = gets.chomp.upcase
			save_game if letter == "1"

			if incorrect.include?(letter) || correct.include?(letter)
				puts "That letter has already been used!"
				next
			end

			return letter if letter.length == 1 && letter.match?(/[A-Z]/)
		end
	end

	def right_letter?(make_guess)
		if answer.include?(make_guess)
			answer.length.times { |i| (@correct[i] = make_guess) if answer[i] == make_guess }
			true
		else 
			@incorrect << make_guess
			false
		end
	end

	def win?
		@answer == @correct ? true : false
	end

	def finish_game
		puts "The correct word: #{answer.join("")}"
		if win?
			player.level_up
			puts "Congratulations! You win!"
		else
			puts "Sorry, you lose..."
		end

		while true
			player.to_s
			puts "Would you like to start a new game?"
			if gets.chomp.downcase[0] == 'y'
				restart_keep_points
				play_game
			else
				break
			end
		end
	end

	def restart_keep_points
		@answer = pick_a_word.split("")
		@mistakes = 0
		@correct = Array.new(answer.length) { "_" }
		@incorrect = Array.new
	end

	def select_file
		while true
			puts "Please select a game file: (1) (2) (3)"
			@filename = gets.chomp
			break if filename.match?(/[123]/)
		end
	end

	def save_game
		Dir.mkdir("saved_games") unless Dir.exists? "saved_games"
		if filename.nil?
		  select_file
		end

		File.open("saved_games/#{filename}.yaml",'w') do |file|
			save = YAML::dump({
				player: @player,
				answer: @answer,
				mistakes: @mistakes,
				correct: @correct,
				incorrect: @incorrect,
				filename: @filename
			})
			file.puts save
		end
		
		puts "Saving..."
		sleep(2)
		exit
	end

	def load_game
		select_file
		
		if File.exist? "saved_games/#{filename}.yaml"
			saved_info = YAML::load File.read("saved_games/#{filename}.yaml")
			@player = saved_info[:player]
			@answer = saved_info[:answer]
			@mistakes = saved_info[:mistakes]
			@correct = saved_info[:correct]
			@incorrect = saved_info[:incorrect]
			@filename = saved_info[:filename]
			puts "Loading previous game..."
		else
			puts "Sorry, that file does not contain a saved game. Starting new game..."
		end
		sleep(3)
	end
end

game = Game.new

