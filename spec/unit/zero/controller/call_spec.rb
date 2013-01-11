require 'spec_helper'

describe Zero::Controller, '.call' do
  let(:object) { create_controller }
  subject { object.call(env) }
  let(:env) { EnvGenerator.get('/foo') }

  before :each do
    object.renderer = Object.new
    object.response = Zero::Response
    object.request  = Zero::Request
  end

  it "returns a response" do
    subject.should be_respond_to(:to_a)
  end

  it "returns an object with the first element being a status" do
    subject[0].should be_kind_of(Numeric)
  end

  it "does not modify an existing request" do
    r = Zero::Request.new(env)
    r.params['foo'] = 'bar'
    subject
    r = Zero::Request.new(env)
    expect(r.params['foo']).to eq('bar')
  end

  context "with the response" do
    let(:response_class) { mock }
    before :each do
      object.response = response_class
      response_class.should_receive(:new).and_return(Zero::Response.new)
    end

    after :each do
      Zero::Controller.response = nil
    end

    it { subject }
  end
end
