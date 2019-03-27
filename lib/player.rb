class Player
	attr_accessor :name, :score
	
	def initialize(name)
		@name = name
		@score = 0
	end

	def level_up
		@score += 1
	end

	def to_s
		puts "Player: #{@name}\n"
		puts "Score: #{@score}\n\n"
	end

end