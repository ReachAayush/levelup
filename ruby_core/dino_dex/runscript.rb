# A brief test

require_relative 'dino_dex.rb'

dex = DinoDex.new
dex.read('dinodex.csv')
puts dex.in_period('Cretaceous')

newdex = DinoDex.new
newdex.read('african_dinosaur_export.csv')
puts newdex.carnivores

puts newdex.query(name: 'Afrovenator')
