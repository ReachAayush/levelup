require 'CSV'

# DinoDex is a class that manages the information about various Dinosaurs
class DinoDex
  attr_accessor :dinos

  # I assume this is an init idiom since it was used in robot name
  def initialize(args = {})
    @dinos = []
    @dinos.replace(args[:dinos]) if args[:dinos]
  end

  def clone
    DinoDex.new(dinos: @dinos)
  end

  def bipeds
    newdex = clone
    newdex.dinos.keep_if(:biped?)
  end

  def carnivores
    newdex = clone
    newdex.dinos.keep_if(:biped?)
  end

  def in_period(period)
    newdex = clone
    newdex.dinos.keep_if { |d| d.period?(period) }
  end

  def big_dinos
    newdex = clone
    newdex.dinos.keep_if(:big?)
  end

  def to_s
    str = "DinoDex Entries\n"
    dinos.each { |d| str += d.to_s }
  end

  def read(csv)
    CSV.foreach(csv) { |row| add_row(row) }
  end

  def add_row(row)
    h = {}
    h[:name] = row[0]
    h[:period] = row[1]
    h[:continent] = row[2]
    h[:diet] = row[3]
    h[:weight] = row[4]
    h[:walking] = row[5]
    h[:description] = row[6]
    dinos << Dinosaur.new(h)
  end
end

# Dinosaur is a class that tracks to information for an individual species
class Dinosaur
  attr_accessor :name, :period, :continent, :walking, :diet, :weight, :description

  def initialize(args = {})
    args.each do |k, v|
      instance_variable_set("@#{k}", v || '')
    end
  end

  def biped?
    walking == 'Biped'
  end

  def carnivore?
    %w(Carnivore Piscivore Insectivore).include?(diet)
  end

  def period?(match_period)
    period =~ /((Early|Late)\s)?#{match_period}/
  end

  def big?
    weight >= 2000
  end

  def to_s
    str = ''
    str += "name: #{name}\n" unless name.empty?
    str += "period: #{period}\n" unless period.empty?
    str += "continent: #{continent}\n" unless continent.empty?
    str += "diet: #{diet}\n" unless diet.empty?
    str += "weight: #{weight}\n" unless weight.empty?
    str += "walking: #{walking}\n" unless walking.empty?
    str += "description: #{description}\n" unless description.empty?
    str + "\n"
  end
end

dex = DinoDex.new
dex.read('dinodex.csv')
# puts dex
puts dex.in_period('Cretaceous')
