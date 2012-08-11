#!/usr/bin/env ruby

path = File.dirname($0)
['gene', 'person'].each { |dependency| require File.join('.', *path, dependency) }

people = []
people << Person.male
people << Person.female

stats = {
:births => 0,
:deaths => 0,
:children => 0,
"max children men" => 0,
"max children women" => 0,
"max age" => 0,
:population => 0,
}

years = 100

(0...(years * 12)).each do |month|
	break if people.empty?
	puts "#{month / 12} #{people.size}" if month % 12 == 0

	people.each do |person|
		if person.wants_to_mate?
			if (other = people.sample).wants_to_mate?
				person + other
			end
		end
	end

	people.reverse_each do |person|
		# if they die
		if rand < person.chance_of_death
			stats["max age"] = person.age if person.age > stats["max age"]
			stats["max children men"] = person.children if person.male and person.children > stats["max children men"]
			stats["max children women"] = person.children if person.female and person.children > stats["max children women"]
			stats[:children] += person.children
			stats[:deaths] +=1
			people.delete person
		end
	end

	people.each do |person|
		if baby = person.birth
			people << baby
			stats[:births] += 1
		end
	end

	people.each(&:live)
end

stats[:population] = people.size
stats[:children] /= stats[:deaths]
stats["max age"] /= 12.0
stats[:men] = people.reject { |p| p.female }.size
stats[:women] = people.size - stats[:men]
stats.each_pair { |k,v| puts "#{k}: #{v}"}
