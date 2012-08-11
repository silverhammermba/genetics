class Node
	def initialize
		@edges = []
	end
end

class Edge
	def initialize a, b
		@node = {}
		@node[a] = b
		@node[b] = a
	end

	def [] *args
		@node[*args]
	end
end

class Graph
end
