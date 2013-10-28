# encoding: UTF-8
require 'spec_helper'

describe Zero::Response do
  subject { Zero::Response.new() }

  describe '#to_a' do
    it "returns an array within status header and body" do
      subject.status = 200
      subject.header = {}
      subject.body   = []

      value = subject.to_a

      value.should be_an_instance_of(Array)
      value[0].should eq(200) # Status code
      value[1].should be_an_instance_of(Hash)  # Headers
      value[2].should eq([])  # Body
    end

    it "returns the content length in the header" do
      subject.body = ['foobar']
      value = subject.to_a

      value[1]['Content-Length'].should eq('6')  # Headers
    end

    it "does not fix the Content-Length, if it's already set" do
      subject.body = ['foobar']
      subject.header = {'Content-Length' => '3'}
      value = subject.to_a

      value[1]['Content-Length'].should eq('3')  # Headers
    end

    it "returns the Content-Type in the header" do
      subject.header = {'Content-Type' => 'application/json'}
      value = subject.to_a

      value[1]['Content-Type'].should eq('application/json')  # Headers
    end

    it "returns as default 'text/html' as Content-Type" do
      value = subject.to_a

      value[1]['Content-Type'].should eq('text/html')  # Headers
    end

    it "removes Content-Type, Content-Length and body on status code 204" do
      subject.body.push '"foobar"'
      subject.content_type = 'application/json'
      subject.header['Content-Length'] = 8

      subject.status = 204
      value = subject.to_a

      value[1].should eq({})  # Headers
      value[2].should eq([])  # Body
    end

    it "removes Content-Type, Content-Length and body on status code 304" do
      subject.body.push '"foobar"'
      subject.content_type = 'application/json'
      subject.header['Content-Length'] = 8

      subject.status = 304
      value = subject.to_a

      value[1].should eq({})  # Headers
      value[2].should eq([])  # Body
    end

    it "adds the cookie to the headers" do
      key = 'key'
      value = 'value'
      subject.cookie.add_crumb(key, value)
      expect(subject.to_a[1]['Set-Cookie']).to eq("#{key}=#{value}")
    end
  end
end
