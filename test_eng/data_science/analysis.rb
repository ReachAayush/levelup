require 'abanalyzer'

class InputError < RuntimeError
end

# Analysis is a class that will do an AB Analysis on it's input data
class Analysis
  def initialize(data)
    @cohorts = {}
    @values = data
    @test = ABAnalyzer::ABTest.new(@values)
    data.each do |k, v|
      @cohorts[k] = Cohort.new(k, v[:success], v[:failure])
    end
  end

  def num_conversions(cohort)
    @cohorts[cohort].success
  end

  def sample_size(cohort)
    @cohorts[cohort].success + @cohorts[cohort].failure
  end

  def conversion_rate(cohort)
    num_conversions(cohort).to_f / sample_size(cohort).to_f
  end

  def conversion_upper_bound(cohort)
    ABAnalyzer.confidence_interval(
      num_conversions(cohort),
      sample_size(cohort),
      0.95)[1]
  end

  def conversion_lower_bound(cohort)
    ABAnalyzer.confidence_interval(
      num_conversions(cohort),
      sample_size(cohort),
      0.95)[0]
  end

  def independence_test
    1 - @test.chisquare_p
  end

  # Cohort is a data class for each cohort in our Analysis
  # don't use this yo
  class Cohort
    attr_accessor :name, :success, :failure

    def initialize(name, success, failure)
      validate_data(success, failure)
      @name = name
      @success = success
      @failure = failure
    end

    def validate_data(success, failure)
      fail InputError, 'negative success count' if success < 0
      fail InputError, 'negative failure count' if failure < 0
    end
  end
end
