require 'spec_helper'

describe Zero::Request, '#post?' do
  subject { Zero::Request.new(env) }

  context "with a post request" do
    let(:env) { EnvGenerator.post('/foo') }
    its(:post?) { should be(true) }
  end

  context "with a get request" do
    let(:env) { EnvGenerator.get('/foo') }
    its(:post?) { should be(false) }
  end
end
