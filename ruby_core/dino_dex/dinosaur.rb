
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

  private
  
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
