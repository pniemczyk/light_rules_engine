require 'spec_helper'

describe LightRulesEngine::Operators::All do
  subject { described_class }
  it 'returns true when all arguments are true' do
    expect(subject.result(true, true, true)).to eq(true)
  end

  it 'returns false when at least one argument is false' do
    expect(subject.result(true, false, true)).to eq(false)
  end
end
