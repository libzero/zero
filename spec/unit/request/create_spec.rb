require 'spec_helper'

describe Zero::Request, '.create' do
  subject { Zero::Request.new(env) }

  context "with a fresh environment" do
    let(:env) { EnvGenerator.get('/foo') }
    it "creates an instance of Zero::Request" do
      Zero::Request.create(env).should be_an_instance_of(Zero::Request)
    end
  end

  context "with an already used environment" do
    let(:env) { EnvGenerator.get('/foo') }
    let(:new_env) { subject.env }

    it "returns an already build request" do
      Zero::Request.create(new_env).should be(subject)
    end
  end
end
