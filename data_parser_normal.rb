require 'csv'


class Delivery
  attr_accessor :destination, :money
end

class Person
  attr_accessor :name, :bonus, :deliveries

  def initialize name, bonus = 0, deliveries = 0
    self.name = name
    self.bonus = bonus
  end

  def find_bonus money
    self.bonus = money * 0.10
  end
end

deliveries = []
CSV.foreach("./planet_express_logs.csv", headers: true) do |line|
  delivery = Delivery.new
  delivery.destination = line.to_hash["Destination"]
  delivery.money = line.to_hash["Money we made"].to_f
  deliveries << delivery
end

def total_money(deliveries)
  monies = deliveries.map do |delivery|
    delivery.money
  end.reduce(:+)
end

def deliveries_for(deliveries, destination)
  deliveries.select do |delivery|
    delivery.destination == destination
  end
end

pluto = deliveries_for(deliveries,"Pluto")
mars = deliveries_for(deliveries,"Mars")
uranus = deliveries_for(deliveries,"Uranus")
saturn = deliveries_for(deliveries,"Saturn")
moon = deliveries_for(deliveries,"Moon")
mercury = deliveries_for(deliveries,"Mercury")
jupiter = deliveries_for(deliveries,"Jupiter")
earth = deliveries_for(deliveries,"Earth")

crew = [
  fry = Person.new("Fry"),
  bender = Person.new("Bender"),
  amy = Person.new("Amy"),
  leela = Person.new("Leela")
]

# Fry
fry.deliveries = earth.count
fry.bonus = fry.find_bonus(total_money(earth))

# Bender

bender.deliveries = uranus.count
bender.bonus = bender.find_bonus(total_money(uranus))

# Amy
amy.deliveries = mars.count
amy.bonus = amy.find_bonus(total_money(mars))

# Leela
leela.deliveries = [saturn.count, moon.count, mercury.count, jupiter.count, pluto.count].reduce(:+)
leela.bonus = (
leela.find_bonus(total_money(saturn)) + leela.find_bonus(total_money(moon)) +
leela.find_bonus(total_money(mercury)) + leela.find_bonus(total_money(jupiter)) +
leela.find_bonus(total_money(pluto))
)

# Output

puts
puts "Hey, Hermes! We made $#{total_money(deliveries)} this week, so please don't fire us again!"
puts
puts "On another note, here's what you owe the crew:"
puts

crew.each do |crew|
  puts "#{crew.name} made #{crew.deliveries} deliveries and received a bonus of $#{crew.bonus}."
end

puts "That's enough to make robot Nixon jealous!"
puts
puts "Here's what we made at each destination:"
puts


planets = [mercury, earth, moon, mars, jupiter, saturn, uranus, pluto]

planets.each do |planet|
  puts "* #{planet.first.destination}: $#{total_money(planet)}"
end
