require 'spec_helper'

describe Zero::Controller, '.call' do
  subject { SpecController.call(env) }
  let(:env) { EnvGenerator.get('/foo') }

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
    r = Zero::Request.create(env)
    expect(r.params['foo']).to eq('bar')
  end
end
