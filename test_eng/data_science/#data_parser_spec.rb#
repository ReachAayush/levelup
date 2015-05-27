require_relative 'data_parser'

# file test.json includes the test data
# file fake_test.json ought not exist

describe DataParser do
  it 'should not throw an error while opening a file' do
    expect { DataParser.new('test.json') }
      .not_to raise_error
  end

  it 'should return correctly formatted data' do
    d = DataParser.new('test.json')
    expect(validate_test_data(d.data))
      .to be_truthy
  end

  it "should raise an exception for a file that doesn't exist" do
    expect { DataParser.new('fake_test.json') }
      .to raise_error
  end

  it 'should raise an exception for invalid json' do
    expect { DataParser.new('invalid.json') }
      .to raise_error
  end

  it 'should raise an exception for malformed file' do
    expect { DataParser.new('malformed.json').data }
      .to raise_error(ParseError)
  end
end

def validate_test_data(data)
  return false unless data['A'][:success] == 3
  return false unless data['A'][:failure] == 1
  return false unless data['B'][:success] == 1
  return false unless data['B'][:failure] == 3
  true
end
