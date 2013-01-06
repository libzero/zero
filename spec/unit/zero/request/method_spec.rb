require 'spec_helper'

describe Zero::Request, '#method' do
  subject { Zero::Request.new(env) }
  let(:env) { EnvGenerator.get('/foo') }

  its(:method) { should == :get }
end
