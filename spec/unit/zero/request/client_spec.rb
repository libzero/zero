require 'spec_helper'

describe Zero::Request, '#client' do
  subject { Zero::Request.new(env) }
  let(:env) { EnvGenerator.get('/foo') }

  its(:client) { should be_an_instance_of(Zero::Request::Client) }
end
