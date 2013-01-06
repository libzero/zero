# encoding: UTF-8
require 'spec_helper'

describe Zero::Response do
  subject { Zero::Response.new() }

  describe '#header' do
    it "must return an empty hash, if no header was set" do
      subject.header.should eq({})
    end
  end
end
