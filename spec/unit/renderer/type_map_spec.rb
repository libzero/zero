require 'spec_helper'

describe Zero::Renderer, '#type_map' do
  subject { Zero::Renderer.new(template_path, type_map) }
  let(:template_path) { 'foo' }
  let(:type_map) { {'html' => ['text/html']} }

  its(:type_map) { should be(type_map) }

  it 'returns an empty Hash, if type_map is not set while initialization' do
    Zero::Renderer.new(template_path).type_map.should eq({})
  end
end
