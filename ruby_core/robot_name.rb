class NameCollisionError < RuntimeError; end

# Robot is a class to store information about robots
class Robot
  attr_accessor :name

  def initialize(args = {})
    @@registry ||= []

    # can these be combined?
    @name_generator = args[:name_generator]
    @name_generator ||= method(:default_name_gen)
   
    @name = @name_generator.call
    validate_name
  end

  def default_name_gen
    @name = "#{gen_char}#{gen_char}#{gen_num}#{gen_num}#{gen_numc}"
  end

  def validate_name
    unless unique?(name)
      fail NameCollisionError, 'There was a problem generating the robot name!'
    end
    @@registry << @name
  end
 
  def unique?(name)
    name =~ /[[:alpha:]]{2}[[:digit:]]{3}/ && !(@@registry.include?(name))
  end

  def gen_char
    ('A'..'Z').to_a.sample
  end

  def gen_num
    rand(10)
  end
end

robot = Robot.new
puts "My pet robot's name is #{robot.name}, but we usually call him sparky."

# Errors!
# generator = -> { 'AA111' }
# Robot.new(name_generator: generator)
# Robot.new(name_generator: generator)
