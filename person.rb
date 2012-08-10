class Person
	def self.sample
		new *Array.new(10) { Gene.sample }
	end

	def initialize time, *genes
		@female = rand < 0.5
		@genes = genes
		@born = time
	end

	def age time
		time - @born
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

	def to_s
		@genes.to_s
	end

	attr_reader :female, :genes

	def male
		not female
	end

	def + person
		if @female != person.female
			self.class.new *@genes.zip(person.genes).map { |g1, g2| g1 + g2 }
		end
	end
end
