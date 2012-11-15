require 'spec_helper'

describe Zero::Request, '#media_types' do
  subject { Zero::Request.new(env) }
  let(:env) { EnvGenerator.get('/foo') }
  its(:media_types) { should be_an_instance_of(Zero::Request::Accept) }
end
