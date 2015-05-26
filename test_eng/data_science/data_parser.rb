require 'json'

class ParseError < RuntimeError
end

class DataParser
  def initialize(filename)
    @file = File.read(filename)
    @raw = JSON.parse(@file)
    @data = {}
  end

  def data
    @raw.each do |row|
      validate_row(row)
      init_cohort(row['cohort'])
      parse_result(row)
    end
    @data
  end

  private

  def validate_row(row)
    fail ParseError, 'no cohort section' unless row.key?('cohort')
    fail ParseError, 'no result section' unless row.key?('result')
  end

  # it seems to suck that I have to call this
  def init_cohort(cohort)
    @data[cohort] ||= {}
    @data[cohort][:success] ||= 0
    @data[cohort][:failure] ||= 0
  end

  def parse_result(row)
    if row['result'] == 1
      @data[row['cohort']][:success] += 1
    else
      @data[row['cohort']][:failure] += 1
    end
  end
end
