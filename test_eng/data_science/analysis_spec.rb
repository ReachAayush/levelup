require_relative 'analysis'
require 'test/unit/assertions.rb'

TEST_DATA = [
  { cohort: 'A', size: 200, conversion: 0.8 },
  { cohort: 'B', size: 300, conversion: 0.5 }
]

describe Analysis do
  it "should return a total number of conversions" do
    a = Analysis.new(TEST_DATA)
    expect(a.num_conversions('A')).to eq(160)
    expect(a.num_conversions('B')).to eq(150)
  end
end

