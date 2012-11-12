require 'spec_helper'

describe Zero::Request do
  subject { Zero::Request.new(env) }

  context "with a get request" do
    let(:env) { EnvGenerator.get('/foo') }
    its(:get?) { should be(true) }
  end

  context "with a post request" do
    let(:env) { EnvGenerator.post('/foo') }
    its(:get?) { should be(false) }
  end
end
