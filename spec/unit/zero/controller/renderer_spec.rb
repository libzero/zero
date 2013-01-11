require 'spec_helper'

describe Zero::Controller, '#renderer' do
  subject { create_controller }
  let(:renderer) { Object.new }

  before do
    subject.response = Zero::Response
    subject.request  = Zero::Request
  end

  it 'returns the set renderer' do
    subject.renderer = renderer
    p subject.renderer
    expect(subject.new({}).renderer).to be(renderer)
  end
end
