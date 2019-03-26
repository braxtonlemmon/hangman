class Board
	attr_accessor

	def initialize
	end

	def show(good, bad, mistakes)
		puts "\n*****************************************************"
		puts "Incorrect guesses:   [ #{bad.join(" | ")} ]\n\n"
		puts "So far:              [ #{good.join(" | ")} ]\n\n"
		wrong = (1..6).map { |i| i <= mistakes ? "X" : "_" }
		puts "Mistakes:            [ #{wrong.join(" | ")} ]\n\n"
		puts "*****************************************************\n\n"
	end

end