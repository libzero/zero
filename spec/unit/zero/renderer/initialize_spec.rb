require 'spec_helper'

describe Zero::Renderer, '#initialize' do
  subject { described_class.new(template_path, type_map) }
  let(:template_path) { 'foo/' }
  let(:type_map) { {'html' => ['text/html'] } }

  its(:path)   { should be(template_path) }
  its(:layout) { should match(/layout/) }
  its(:types)  { should be(type_map) }
end
