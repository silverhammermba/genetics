def probability_for_deaths range, p
	1 - (1 - p) ** Rational(1, (range.end - range.begin) * 12)
end

class Person
	def self.male
		p = sample
		p.instance_eval { @female = false }
		p
	end

	def self.female
		p = sample
		p.instance_eval { @female = true }
		p
	end

	def self.sample
		new 0, *Array.new(10) { Gene.sample }
	end

	def initialize time, *genes
		@female = rand < 0.5
		@genes = genes
		@born = time
		@time = time
		@children = 0
		@chance_to_mate = 0
	end

	def live
		@time += 1
		@wants_to_mate = rand < @chance_to_mate and rand > (age / 100.0)
		if can_reproduce?
			@chance_to_mate += rand * 0.2
		end
	end

	def age
		@time - @born
	end

	def mature?
		age >= (14 * 12)
	end

	def can_reproduce?
		if @female
			mature? and age <= (50 * 12)
		else
			mature?
		end
	end

	def chance_of_death
		if age < (5 * 12)
			#probability_for_deaths(0..5, 0.01)
			0.00016
		elsif age < (40 * 12)
			#probability_for_deaths(5..40, 0.02)
			0.000048
		elsif age < (70 * 12)
			#probability_for_deaths(40..70, 0.03)
			0.000085
		elsif age < (100 * 12)
			#probability_for_deaths(70..100, 0.99)
			0.0127
		else
			1
		end
	end

	def to_s
		@genes.to_s
	end

	attr_reader :female, :genes
	attr_accessor :pregnant, :children, :chance_to_mate, :wants_to_mate

	def male
		not female
	end

	def + person
		@chance_to_mate = 0
		person.chance_to_mate = 0
		@wants_to_mate = false
		person.wants_to_mate = false
		if @female != person.female and can_reproduce? and person.can_reproduce?
			woman = (@female? self : person)
			unless woman.pregnant
				woman.pregnant = [@time + 9, self.class.new(@time + 9, *@genes.zip(person.genes).map { |g1, g2| g1 + g2 })]
				@children += 1
				person.children += 1
			end
		end
	end

	def birth
		if @pregnant and @pregnant[0] == @time
			baby = @pregnant[1]
			@pregnant = nil
			baby
		end
	end
end
