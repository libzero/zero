require 'spec_helper'

describe Zero::Controller, '#renderer' do
  subject { create_controller }
  let(:renderer) { Object.new }

  it 'returns the set renderer' do
    subject.renderer = renderer
    expect(subject.new({}).renderer).to be(renderer)
  end
end
