require 'CSV'

class DinoParser
  attr_accessor :rows
  HEADERS = {
    'NAME' => :name,
    'PERIOD' => :period,
    'CONTINENT' => :continent,
    'DIET' => :diet,
    'WEIGHT_IN_LBS' => :weight,
    'WALKING' => :walking,
    'DESCRIPTION' => :description,
    'Genus' => :name,
    'Period' => :period,
    'Carnivore' => :carnivore,
    'Weight' => :weight,
    'Walking' => :walking
  }

  def initialize(csv)
    @data_indices = {}
    @rows = CSV.read(csv)
    parse_headers(rows.shift)
  end

  def dinos
    dinos = []
    while rows.length != 0 do
      dinos << Dinosaur.new(parse_row(rows.shift))
    end
    return dinos
  end
  
  private
  def parse_headers(head)
    head.each_index do |i|
      @data_indices[i] = HEADERS[head[i]]
    end
  end

  def parse_row(row)
    dino = {}
    row.each_index do |i|
      dino[@data_indices[i]] = row[i]
    end
    carnivore_fix(dino)
    return dino
  end

  def carnivore_fix(dino)
    # we have to do the hardcode somewhere, I chose here
    if dino[:carnivore] == 'Yes'
      dino[:diet] = 'Carnivore'
    elsif dino[:carnivore] == 'No'
      dino[:diet] = 'Herbivore'
    end
  end
end  

# DinoDex is a class that manages the information about various Dinosaurs
class DinoDex
  attr_accessor :dinos

  # I assume this is an init idiom since it was used in robot name
  def initialize(args = {})
    @dinos = []
    @dinos.replace(args[:dinos]) if args[:dinos]
  end

  def read(csv)
    reader = DinoParser.new(csv)
    @dinos.replace(reader.dinos)
  end
  
  def clone
    DinoDex.new(dinos: @dinos)
  end

  def bipeds
    newdex = clone
    newdex.dinos.keep_if(&:biped?)
  end

  def carnivores
    newdex = clone
    newdex.dinos.keep_if(&:carnivore?)
  end

  def in_period(period)
    newdex = clone
    newdex.dinos.keep_if { |d| d.period?(period) }
  end

  def big_dinos
    newdex = clone
    newdex.dinos.keep_if(&:big?)
  end

  def query(hash)
    newdex = clone
    newdex.dinos.keep_if do |d|
      dino_matches_hash?(d, hash)
    end
  end
  
  def to_s
    str = "DinoDex Entries\n"
    dinos.each { |d| str += d.to_s }
  end

  private
  def dino_matches_hash?(dino, hash)
    hash.all? { |k, v| dino.send(k) == v }
  end
end

# Dinosaur is a class that tracks to information for an individual species
class Dinosaur
  DATA_TYPES = [:name, :period, :continent, :walking, :diet, :weight, :description, :carnivore]
  attr_accessor *DATA_TYPES

  def initialize(args = {})
    DATA_TYPES.each do |var|
      instance_variable_set("@#{var}", args[var] || '')
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
    instance_variables.each do |var|
      str += "#{var}: #{instance_variable_get(var)}\n" unless instance_variable_get(var).empty?
    end
    str + "\n"
  end
end

dex = DinoDex.new
dex.read('dinodex.csv')
puts dex.in_period('Cretaceous')

newdex = DinoDex.new
newdex.read('african_dinosaur_export.csv')
puts newdex.carnivores

puts newdex.query(name: "Afrovenator")
