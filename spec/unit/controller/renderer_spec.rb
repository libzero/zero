require 'spec_helper'

describe Zero::Controller, '#renderer' do
  subject { Zero::Controller }
  let(:renderer) { Object.new }
  
  it 'returns the set renderer' do
    subject.renderer = renderer
    expect(subject.new(Object.new).renderer).to be(renderer)
  end
end
