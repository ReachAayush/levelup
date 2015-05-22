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

  it "should return a sample size for each cohort" do
    a = Analysis.new(TEST_DATA)
    expect(a.sample_size('A')).to eq(200)
    expect(a.sample_size('B')).to eq(300)
  end

  it "should raise an error on negative size" do
    expect { Analysis.new([{ cohort: 'A', size: -10, conversion: 0.8 }]) }.
      to raise_error(InputError)
  end

  it "should raise an error on conversion out of bounds" do
    expect { Analysis.new([{ cohort: 'A', size: 10, conversion: -2 }]) }.
      to raise_error(InputError)
    expect { Analysis.new([{ cohort: 'A', size: 10, conversion: 20 }]) }.
      to raise_error(InputError)
  end
end

