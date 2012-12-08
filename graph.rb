class Node
	def initialize contents
		@edges = []
		@contents = contents
	end

	def method_missing? meth, *args, &blk
		@contents.send(meth, *args &blk)
	end

	attr_reader :edges
end

class Edge
	def initialize a, b
		@node = {}
		@node[a] = b
		@node[b] = a
	end

	def nodes
		@node.keys
	end

	def [] *args
		@node[*args]
	end
end

class Graph
	def initialize
		@nodes = []
		@edges = []
	end

	attr_reader :nodes, :edges

	def add node
		e = []

		@nodes << node

	end
end
