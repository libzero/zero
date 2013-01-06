require 'spec_helper'

describe Zero::Request, '#accept' do
  subject { Zero::Request.new(env) }
  let(:env) { EnvGenerator.get('/foo') }
  its(:accept) { should be_an_instance_of(Zero::Request::Accept) }
end
