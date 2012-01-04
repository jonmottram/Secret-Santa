#!/usr/bin/env ruby
class Person 
  attr_reader :first, :last, :email, :last_time
  attr_accessor :santa

  def initialize(line)
    m = /\"(\S+)\s+(\S+)\s+(\S+)\s+(\S+).*\"/.match(line)
    raise unless m
    @first = m[1].capitalize
    @last = m[2].capitalize
    @email = m[3]
    @last_time = m[4].capitalize
  end

  def can_be_santa_of?(other)
    @last != other.last && @last_time != other.first 
  end
end

kidz_names = [
"Josie Mottram <josie@josieq.com>",
"Andrew Mottram <andrew@josieq.com>",
"Jack Motr <jack@kemo.com>",
"Gavin Motr <jack@kemo.com>",
"Lila Motr <jack@kemo.com>",
"Billy Motor <billy@steve.com>",
"Bryan Motor <billy@steve.com>"
]
motr_names = [
"Jon Mottram <jomo@motor.com>",
"Steph Mottram <steph@steph.com>",
"Keith Motr <kemo@m.m>",
"Kristin Motr <kris@m.m>",
"Steve Motor <stemo@mo.mo>",
"Kris Motor <kris@mo.mo>",
"Skip Mo <skip@mot.mot>",
"Della Mo <della@mot.mot>"
]
prin_names = [
"Tony Prinster <tony@tonyprinster.com>",
"Sally Prinster <sally@tonyprinster.com>",
"Michael Chaffee <michael@chaffee.com>",
"Nia Chaffee <nia@chaffee.com>",
"Sarah Coomster <sarah@coomster.com>",
"John Coomster <sarah@coomster.com>",
"Stephanie Mottram <steph@mottram.com>",
"Jon Mottram <jon@mottram.com>"
]

people = []
STDIN.read.each_line do |line|
  line.strip!
  people << Person.new(line) unless line.empty?
end

srand 2011
santas = people.dup
people.each do |person|
  person.santa = santas.delete_at(rand(santas.size))
end

people.each do |person|
  unless person.santa.can_be_santa_of? person
    candidates = people.select { |p|
      p.santa.can_be_santa_of?(person) &&
      person.santa.can_be_santa_of?(p)
    }
    raise if candidates.empty?
    other = candidates[rand(candidates.size)]
    temp = person.santa
    person.santa = other.santa
    other.santa = temp
    finished = false
  end
end

people.each do |person|
  printf "%s -> %s\n", person.santa.first, person.first
end
