require_relative 'dino_parser.rb'
require_relative 'dinosaur.rb'

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
