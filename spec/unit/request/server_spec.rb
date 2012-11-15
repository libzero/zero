require 'spec_helper'

describe Zero::Request, '#server' do
  subject { Zero::Request.new(env) }
  let(:env) { EnvGenerator.get('/foo') }

  its(:server) { should be_an_instance_of(Zero::Request::Server) }
end
