require 'spec_helper'

describe LightRulesEngine::Operators::Any do
  subject { described_class }
  it 'returns true when any argument is true' do
    expect(subject.result(false, false, true)).to eq(true)
  end

  it 'returns false all arguments are false' do
    expect(subject.result(false, false, false)).to eq(false)
  end
end
