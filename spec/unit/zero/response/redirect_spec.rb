# encoding: UTF-8
require 'spec_helper'

describe Zero::Response do
  subject { Zero::Response.new() }

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
