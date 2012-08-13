class Allele
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

class Gene
	@@mutation_rate = 0.1

	def self.sample
		new *Array.new(2) { Allele::pool.sample }
	end

	def initialize a1, a2
		@alleles = [a1, a2].sort_by(&:to_s)
	end

	attr_reader :alleles

	def to_s
		@alleles.join
	end

	def dominant?
		@alleles.any? { |a| a.dominant }
	end

	def random_allele
		# choose a random allele or mutate
		if rand < @@mutation_rate
			Allele::pool.sample
		else
			@alleles.sample
		end
	end

	def + gene
		# choose alleles
		als = [random_allele, gene.random_allele]

		self.class.new *als
	end
end
