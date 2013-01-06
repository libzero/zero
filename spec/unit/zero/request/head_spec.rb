require 'spec_helper'

describe Zero::Request, '#head?' do
  subject { Zero::Request.new(env) }

  context "with a head request" do
    let(:env) { EnvGenerator.head('/foo') }
    its(:head?) { should be(true) }
  end

  context "with a get request" do
    let(:env) { EnvGenerator.get('/foo') }
    its(:head?) { should be(false) }
  end
end
