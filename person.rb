def probability_for_deaths range, p
	1 - (1 - p) ** Rational(1, (range.end - range.begin) * 12)
end

class Person
	def self.sample
		new 0, *Array.new(10) { Gene.sample }
	end

	def initialize time, *genes
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
		mature?
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

	attr_reader :genes, :wants_to_mate
	attr_accessor :children

	def + person
		@chance_to_mate = 0
		@wants_to_mate = false
		person.instance_eval do
			@chance_to_mate = 0
			@wants_to_mate = false
		end
	end
end

class Male < Person
end

class Female < Person
	def birth
		if @pregnant and (baby = @pregnant[@time])
			@pregnant = nil
			baby
		end
	end

	def can_reproduce?
		super and age <= (50 * 12) and not @pregnant
	end

	def + person
		super person
		if person.is_a? Male and can_reproduce? and person.can_reproduce?
			sex = rand < 0.5 ? Male : Female
			@pregnant = {@time + 9 => sex.new(@time + 9, *@genes.zip(person.genes).map { |g1, g2| g1 + g2 })}
			@children += 1
			person.children += 1
		end
	end
end
