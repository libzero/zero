require 'spec_helper'

describe Zero::Request, '#put?' do
  subject { Zero::Request.new(env) }

  context "with a put request" do
    let(:env) { EnvGenerator.put('/foo') }
    its(:put?) { should be(true) }
  end

  context "with a get request" do
    let(:env) { EnvGenerator.get('/foo') }
    its(:put?) { should be(false) }
  end
end
