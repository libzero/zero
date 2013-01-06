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
  end

  describe '#status' do
    it "must return the status always as an integer" do
      subject.status = "foobar"
      subject.status.should eq(0)

      subject.status = 240.5
      subject.status.should eq(240)
    end

    it "must return 200, if no status code was set" do
      subject.status.should eq(200)
    end
  end

  describe '#header' do
    it "must return an empty hash, if no header was set" do
      subject.header.should eq({})
    end
  end

  describe '#body' do
    it "must return an empty array, if no body was set" do
      subject.body.should eq([])
    end
  end

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

  describe '#content_type' do
    it "sets the Content-Type to the given value" do
      subject.content_type = 'application/json'

      subject.header['Content-Type'].should eq('application/json')
    end
  end

  describe '#redirect' do
    it "sets the status to 302 and the given Location URL in header" do
      subject.redirect 'http://foo.bar/relocated/thingy'
      value = subject.to_a

      value[0].should eq(302)
      value[1]['Location'].should eq('http://foo.bar/relocated/thingy')
    end

    it "sets the given status code and the given Location" do
      subject.redirect('http://foo.bar/relocated/other_thingy', 307)
      value = subject.to_a

      value[0].should eq(307)
      value[1]['Location'].should eq('http://foo.bar/relocated/other_thingy')
    end
  end

end