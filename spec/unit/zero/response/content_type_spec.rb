# encoding: UTF-8
require 'spec_helper'

describe Zero::Response do
  subject { Zero::Response.new() }

  describe '#content_type' do
    it "sets the Content-Type to the given value" do
      subject.content_type = 'application/json'

      subject.header['Content-Type'].should eq('application/json')
    end
  end
end
