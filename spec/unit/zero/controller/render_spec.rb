require 'spec_helper'

describe Zero::Controller, '#render' do
  subject { Zero::Controller.new(env) }
  let(:env) { EnvGenerator.get('/foo') }
  let(:renderer) { mock }
  let(:template) { '/foo' }

  before :each do
    Zero::Controller.renderer = renderer
    renderer.should_receive(:render).with(template,
                                  kind_of(Zero::Request::AcceptType), subject)
  end
  after :each do
    Zero::Controller.renderer = nil
  end

  it { subject.render(template) }
end
