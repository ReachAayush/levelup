class InputError < RuntimeError
end


class Analysis
  def initialize(data)
    @cohorts = {}
    data.each do |c|
      @cohorts[c[:cohort]] = Cohort.new(c[:cohort], c[:size], c[:conversion])
    end
  end

  def num_conversions(cohort)
    c = @cohorts[cohort]
    c.size * c.conversion
  end

  def sample_size(cohort)
    @cohorts[cohort].size
  end
  
  private

  class Cohort
    attr_accessor :name, :size, :conversion

    def initialize(name, size, conversion)
      @name = name
      @size = size
      raise InputError, "negative size" if size < 0
      @conversion = conversion
    end
  end
end
