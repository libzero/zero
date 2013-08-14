require 'spec_helper'

describe Zero::Request, '#method' do
  subject { Zero::Request.new(env) }
  let(:env) { EnvGenerator.get('/foo') }

  its(:method) { should == :get }

  context 'with post requests' do
    context 'and _method defined' do
      let(:env) do
        EnvGenerator.post('/foo', {
          :input => '_method=put',
          'CONTENT_TYPE' => 'multipart/form-data'
        })
      end
      it 'uses _method from the payload to change the method' do
        expect(subject.method).to be(:put)
      end
    end

    context 'and _method not defined' do
      let(:env) do
        EnvGenerator.post('/foo', {
          :input => 'foo=bar',
          'CONTENT_TYPE' => 'multipart/form-data'
        })
      end
      its(:method) { should == :post }
    end

    context 'and _method has wrong content' do
      let(:env) do
        EnvGenerator.post('/foo', {
          :input => '_method=foobar',
          'CONTENT_TYPE' => 'multipart/form-data'
        })
      end
      its(:method) { should == :post }
    end

    context 'and no payload' do
      let(:env) do
        EnvGenerator.post('/foo', {
          'CONTENT_TYPE' => 'multipart/form-data'
        })
      end
      its(:method) { should == :post }
    end
  end
end
