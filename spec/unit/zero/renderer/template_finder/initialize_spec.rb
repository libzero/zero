require 'spec_helper'

describe Zero::Renderer::TemplateFinder, '#initialize' do
  subject { described_class.new(template_path, type_map) }
  let(:template_path) { 'foo/' }
  let(:type_map) { {'html' => ['text/html']} }

  its(:path)       { should be(template_path) }
  its(:path_regex) { should eq(/#{template_path}/) }
  its(:type_map)   { should be(type_map) }

  context 'with broken path' do
    let(:template_path) { 'foo' }

    it "raises an error" do
      expect { subject }.to raise_error(ArgumentError, "Has to end on '/'!")
    end
  end
end
