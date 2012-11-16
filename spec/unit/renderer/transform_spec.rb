require 'spec_helper'

describe Zero::Renderer, '.transform' do
  subject { Zero::Renderer }
  let(:map) {{ 'text/html' => 'html' }}

  shared_examples_for 'a transformer' do
    before :each do
      Zero::Renderer.type_map = map
    end

    after :each do
      Zero::Renderer.type_map = {}
    end

    it "transforms a string" do
      subject.transform(original).should eq(result)
    end
  end

  context "with a shortable type" do
    let(:original) { 'text/html' }
    let(:result) { 'html' }
    it_behaves_like 'a transformer'
  end

  context "with an unshortable type" do
    let(:original) { 'application/json' }
    let(:result) { 'application/json' }
    it_behaves_like 'a transformer'
  end
end
