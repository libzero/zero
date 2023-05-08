require 'spec_helper'

describe Zero::Controller, '#render' do
  let(:object) { create_controller }
  subject { object.new(env) }

  let(:env) { EnvGenerator.get('/foo') }
  let(:renderer) { Object.new }
  let(:template) { '/foo' }

  before :each do
    object.renderer = renderer
    renderer.should_receive(:render).with(template,
                                  kind_of(Zero::Request::AcceptType), subject)
  end
  after :each do
    Zero::Controller.renderer = nil
  end

  it { subject.render(template) }
end
