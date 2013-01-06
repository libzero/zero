require 'spec_helper'

describe Zero::Request, '#delete?' do
  subject { Zero::Request.new(env) }

  context "with a delete request" do
    let(:env) { EnvGenerator.delete('/foo') }
    its(:delete?) { should be(true) }
  end

  context "with a get request" do
    let(:env) { EnvGenerator.get('/foo') }
    its(:delete?) { should be(false) }
  end
end
