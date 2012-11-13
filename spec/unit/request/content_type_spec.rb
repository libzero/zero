require 'spec_helper'

describe Zero::Request, '#content_type' do
  subject { Zero::Request.new(env) }

  context 'returns nil with no content type' do
    let(:env) { EnvGenerator.get('/foo') }
    its('content_type') { should be(nil) }
  end

  context 'returns the set content type' do
    let(:content_type) { 'bogus/type' }
    let(:env) { EnvGenerator.post('/foo', {'CONTENT_TYPE' => content_type}) }
    its('content_type') { should be(content_type) }
  end
end
