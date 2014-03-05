require 'spec_helper'

describe Zero::Request::Client, '#address' do
  subject { Zero::Request::Client.new(env) }

  context 'without a proxy' do
    let(:address) { '127.0.0.1' }
    let(:env) { {'REMOTE_ADDR' => address} }

    its(:address) { should == address }
  end

  context 'with a proxy' do
    let(:proxy)   { '127.0.0.1' }
    let(:address) { '192.168.42.3' }
    let(:env) do
      {
        'REMOTE_ADDR' => proxy,
        'HTTP_X_FORWARDED_FOR' => address
      }
    end

    its(:address) { should == address }
    its(:remote_address) { should == proxy }
    its(:forwarded_for)  { should == address }
  end
end
