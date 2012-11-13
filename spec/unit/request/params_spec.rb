require 'spec_helper'

describe Zero::Request, '#params' do
  subject { Zero::Request.new(env) }
  let(:env) { EnvGenerator.get('/foo?bar=baz') }

  it "returns a Parameter object" do
    subject.params.class.should be(Zero::Request::Parameter)
  end

  it "returns a valid Parameter object" do
    subject.params.query['bar'].should == 'baz'
  end
end
