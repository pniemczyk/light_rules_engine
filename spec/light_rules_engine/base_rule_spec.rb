require 'spec_helper'

describe LightRulesEngine::BaseRule do
  let(:conditions) { double('conditions') }
  let(:source)     { double('source') }
  subject { described_class.new(conditions: conditions, source: source) }
  it '#conditions hold conditions' do
    expect(subject.conditions).to eq(conditions)
  end

  it '#source hold source' do
    expect(subject.source).to eq(source)
  end
end
