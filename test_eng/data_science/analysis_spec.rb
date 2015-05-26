require_relative 'analysis'
require 'test/unit/assertions.rb'

TEST_DATA = {
  'A' => { success: 160, failure: 40 },
  'B' => { success: 150, failure: 150 },
}

FAIL_DATA_A = {
  'A' => { success: -160, failure: 40 },
  'B' => { success: 150, failure: 150 },
}
FAIL_DATA_B = {
  'A' => { success: 160, failure: 40 },
  'B' => { success: 150, failure: -150 },
}

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

  it "should give a lower bound of conversion rate" do
    a = Analysis.new(TEST_DATA)
    expect(a.conversion_lower_bound('A'))
      .to be_within(0.001).of(0.7445638473924556)
  end

  it "should give an upper bound of conversion rate" do
    a = Analysis.new(TEST_DATA)
    expect(a.conversion_upper_bound('A'))
      .to be_within(0.001).of(0.8554361526075445)
  end

  it "should give an estimate of conversion rate" do
    a = Analysis.new(TEST_DATA)
    expect(a.conversion_rate('A'))
      .to be_within(0.001).of(0.8)
  end

  it "should give a confidence that the current leader is better than random" do
    a = Analysis.new(TEST_DATA)
    expect(a.independence_test)
      .to be_within(0.001).of(0.9999999999871716)
  end

  it "should raise an error when passes negative successes" do
    expect { Analysis.new(FAIL_DATA_A) }
      .to raise_error(InputError)
  end

  it "should raise an error when passes negative failures" do
    expect { Analysis.new(FAIL_DATA_B) }
      .to raise_error(InputError)
  end
end
