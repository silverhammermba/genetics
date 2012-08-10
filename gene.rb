class Gene
	@@mutation_rate = 0.1

	def self.sample
		new *Array.new(2) { Alele::pool.sample }
	end

	def initialize a1, a2, mutated = false
		@aleles = [a1, a2].sort_by(&:to_s)
		@mutated = mutated
	end

	attr_reader :aleles, :mutated

	def to_s
		@aleles.join + (@mutated ? '*' : '')
	end

	def dominant?
		@aleles.any? { |a| a.dominant }
	end

	def random_alele
		# choose a random alele or mutate
		if rand < @@mutation_rate
			(Alele::pool - @aleles).sample
		else
			@aleles.sample
		end
	end

	def + gene
		# choose aleles
		als = [random_alele, gene.random_alele]
		# check for (apparent mutations)
		mutation = als.any? { |a| [self, gene].all? { |g| not g.aleles.include?(a) } }

		self.class.new(*als, mutation)
	end
end

class Alele
	def initialize name, dominant
		@name = name
		@dominant = dominant

		@name.upcase! if @dominant
	end

	def to_s
		@name
	end

	name = "`"
	@pool = Array.new(2) { new name.succ!.dup, true } + Array.new(3) { new name.succ!.dup, false }
	singleton_class.class_eval { attr_reader :pool }
	private_class_method :new

	attr_reader :name, :dominant
end
