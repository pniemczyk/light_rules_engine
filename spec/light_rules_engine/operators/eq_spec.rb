require 'spec_helper'

describe LightRulesEngine::Operators::Eq do
  subject { described_class }
  it 'returns true when all arguments are equal' do
    expect(subject.result(1, 1, 1)).to eq(true)
  end

  it 'returns false when any of argument is different' do
    expect(subject.result(1, 1, 2)).to eq(false)
  end
end
