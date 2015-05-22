require 'CSV'

# DinoParser parses the dinos
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
    rows.map do |row|
      Dinosaur.new(parse_row(row))
    end
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
    dino
  end

  def carnivore_fix(dino)
    # we have to do the hardcode somewhere, I chose here
    fix_diet_text(dino)
    fix_carnivore_bool(dino)
  end

  def fix_diet_text(dino)
    if dino[:carnivore] == 'Yes'
      dino[:diet] = 'Carnivore'
    elsif dino[:carnivore] == 'No'
      dino[:diet] = 'Herbivore'
    end
  end

  def fix_carnivore_bool(dino)
    if %w(Carnivore Piscivore Insectivore).include?(dino[:diet])
      dino[:carnivore] = 'Yes'
    else
      dino[:carnivore] = 'No'
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
    query(walking: 'Biped')
  end

  def carnivores
    query(carnivore: 'Yes')
  end

  def in_period(period)
    query({ period: Regexp.new("((Early|Late)[::space::])?#{period}") }, :=~)
  end

  def big_dinos
    query({ weight: 2000 }, :>=)
  end

  def query(hash, op = :==)
    newdex = clone
    newdex.dinos.keep_if do |d|
      dino_comp_hash?(d, hash, op)
    end
  end

  def to_s
    str = "DinoDex Entries\n"
    dinos.each { |d| str += d.to_s }
  end

  private

  def dino_comp_hash?(dino, hash, op)
    hash.all? { |k, v| dino.send(k).send(op, v) }
  end
end

# Dinosaur is a class that tracks to information for an individual species
class Dinosaur
  DATA_TYPES = [:name,
                :period,
                :continent,
                :walking,
                :diet,
                :weight,
                :description,
                :carnivore]

  attr_accessor(*DATA_TYPES)

  def initialize(args = {})
    DATA_TYPES.each do |var|
      instance_variable_set("@#{var}", args[var] || '')
    end
  end

  def to_s
    str = ''
    instance_variables.each { |var| str += var_to_s(var) }
    str + "\n"
  end

  def var_to_s(var)
    if var_printable?(var)
      "#{var}: #{instance_variable_get(var)}\n"
    else
      ''
    end
  end

  def var_printable?(var)
    !instance_variable_get(var).empty?
  end
end

dex = DinoDex.new
dex.read('dinodex.csv')
puts dex.in_period('Cretaceous')

newdex = DinoDex.new
newdex.read('african_dinosaur_export.csv')
puts newdex.carnivores

puts newdex.query(name: 'Afrovenator')
