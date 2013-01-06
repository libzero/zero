require 'spec_helper'

describe Zero::Request::Accept, '#types' do
  subject { Zero::Request::Accept.new(env) }
  let(:media_types) { 'text/html' }
  let(:env) { EnvGenerator.get('/foo', {'HTTP_ACCEPT' => media_types}) }

  it 'sets the media type to the given value' do
    subject.types.preferred.should eq('text/html')
  end
end
