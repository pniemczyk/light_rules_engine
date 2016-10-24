require 'spec_helper'

describe LightRulesEngine::Operators::Range do
  subject { described_class }
  it 'returns true when last argument is between first once' do
    expect(subject.result(1, 3, 2)).to eq(true)
  end

  it 'returns false when last argument is not between first once' do
    expect(subject.result(1, 2, 3)).to eq(false)
  end
end
