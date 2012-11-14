require 'spec_helper'

describe Zero::Request::Accept, '#preferred' do
  subject { Zero::Request::Accept }
  let(:html) { 'text/html' }
  let(:json) { 'application/json' }
  let(:foo)  { 'text/foo' }
  let(:lower_quality) { foo + ';q=0.5' }
  let(:default) { '*/*;q=0.1' }
  let(:simple_accept)  { [html, json].join(',') }
  let(:quality_accept) { [html, lower_quality, default].join(',') }
  let(:random_accept)  { [lower_quality, default, html].join(',') }
  let(:lower_accept)   { [lower_quality, default].join(',') }
  
  context 'without mapping' do
    before :each do
      # reset the mapping to nothing
      Zero::Request::Accept.map = {}
    end

    it { subject.new(html).preferred.should           == html }
    it { subject.new(json).preferred.should           == json }
    it { subject.new(simple_accept).preferred.should  == html }
    it { subject.new(quality_accept).preferred.should == html }
    it { subject.new(random_accept).preferred.should  == html }
    it { subject.new(lower_accept).preferred.should   == foo }
  end

  context 'with mapping' do
    before :all do
      Zero::Request::Accept.map = {'text/html' => 'html'}
    end

    it { subject.new(html).preferred.should == 'html' }
  end
end
