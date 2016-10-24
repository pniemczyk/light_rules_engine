require 'spec_helper'

describe LightRulesEngine::Operators::Lt do
  subject { described_class }
  it 'returns true when each next argument is less than the previous' do
    expect(subject.result(1, 2, 3)).to eq(true)
  end

  it 'returns false when not each next argument is less than the previous' do
    expect(subject.result(1, 2, 1)).to eq(false)
  end
end
