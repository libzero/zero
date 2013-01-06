require 'spec_helper'

describe Zero::Request, '#patch?' do
  subject { Zero::Request.new(env) }

  context "with a patch request" do
    let(:env) { EnvGenerator.patch('/foo') }
    its(:patch?) { should be(true) }
  end

  context "with a get request" do
    let(:env) { EnvGenerator.get('/foo') }
    its(:patch?) { should be(false) }
  end
end
