require 'spec_helper'

describe LightRulesEngine::DataContainerBuilder do
  subject { described_class }

  it 'returns clone original object' do
    object = double('object')
    expect(object).to receive(:clone).and_return(object)
    expect(subject.build(object)).to eq(object)
  end

  it 'returns clone original object encapsulated by struct with proper first argument name' do
    object = double('object')
    expect(object).to receive(:clone).and_return(object)
    expect(subject.build(object, name: :booking).booking).to eq(object)
  end
end

