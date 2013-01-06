# encoding: UTF-8
require 'spec_helper'

describe Zero::Response do
  subject { Zero::Response.new() }

  describe '#content_length' do
    it "sets the Content-Length to '0', if there is no content" do
      subject.content_length

      subject.header['Content-Length'].should eq('0')
    end

    it "sets the Content-Length to the size of the message body" do
      subject.body = ['foo', 'bar']
      subject.content_length

      subject.header['Content-Length'].should eq('6')
    end

     it "sets the Content-Length to the bytesize of the message body" do
      subject.body = ['föö', 'bär']
      subject.content_length

      subject.header['Content-Length'].should eq('9')
    end
  end
end
