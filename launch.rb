#!/usr/bin/env ruby

path = File.dirname($0)
['gene', 'person'].each { |dependency| require File.join('.', *path, dependency) }

people = []
people << Male.sample
people << Female.sample

stats = {
:births => 0,
"deaths women" => 0,
"deaths men" => 0,
"children women" => 0,
"children men" => 0,
"max children men" => 0,
"max children women" => 0,
"childless men" => 0,
"childless women" => 0,
"max age" => 0,
:population => 0,
:willing => 0,
:successful => 0,
}

years = 150

(0...(years * 12)).each do |month|
	break if people.empty?
	print "\x1b[1G\x1b[2Kyear: #{month / 12}\tpop:#{people.size}" if month % 12 == 0

	people.reverse_each do |person|
		# if they die
		if rand < person.chance_of_death
			stats["max age"] = person.age if person.age > stats["max age"]
			stats["max children men"] = person.children if person.is_a? Male and person.children > stats["max children men"]
			stats["max children women"] = person.children if person.is_a? Female and person.children > stats["max children women"]
			stats["children women"] += person.children if person.is_a? Female
			stats["children men"] += person.children if person.is_a? Male
			stats["deaths women"] += 1 if person.is_a? Female
			stats["deaths men"] += 1 if person.is_a? Male
			stats["childless women"] += 1 if person.children == 0 and person.is_a? Female
			stats["childless men"] += 1 if person.children == 0 and person.is_a? Male
			people.delete person
		end
	end

	couples = []

	willing = 0
	people.each do |person|
		if person.wants_to_mate
			willing += 1
			if (other = people.sample).wants_to_mate
				couples << [person, other]
			end
		end
	end

	stats[:willing] += willing
	couples.each { |p1, p2| p1 + p2 }

	stats[:successful] += willing - people.reject { |p| not p.wants_to_mate }.size

	people.each do |person|
		if person.is_a? Female and baby = person.birth
			people << baby
			stats[:births] += 1
		end
	end

	people.each(&:live)
end
puts

#people.each do |person|
#	stats["childless women"] += 1 if person.children == 0 and person.female
#	stats["childless men"] += 1 if person.children == 0 and person.male
#end
stats[:deaths] = stats["deaths women"] + stats["deaths men"]
stats[:population] = people.size
stats["children women"] /= stats["deaths women"].to_f
stats["children men"] /= stats["deaths men"].to_f
stats["max age"] /= 12.0
stats[:willing] /= (years * 12).to_f
stats[:successful] /= (years * 12).to_f
stats[:men] = people.reject { |p| p.is_a? Female }.size
stats[:women] = people.size - stats[:men]
stats.each_pair { |k,v| puts "#{k}: #{v}"}
