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
