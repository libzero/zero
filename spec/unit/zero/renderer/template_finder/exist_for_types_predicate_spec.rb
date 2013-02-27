require 'spec_helper'

describe Zero::Renderer::TemplateFinder, '#exist_for_types?' do
  subject { described_class.new(template_path, type_map) }
  let(:template_path) { 'spec/fixtures/templates/' }
  let(:type_map) { {'html' => 'text/html'} }
  let(:html_types) { ['text/html'] }
  let(:foo_types)  { ['foo/bar', 'bar/foo'] }

  it 'returns true when template exists' do
    expect(subject.exist_for_types?('index', html_types)).to be(true)
  end

  it 'returns false when template does not exist' do
    expect(subject.exist_for_types?('not_found', html_types)).to be(false)
  end

  it 'returns false when template for types does not exists' do
    expect(subject.exist_for_types?('index', foo_types)).to be(false)
  end

  it 'returns false when no types are defined' do
    expect(subject.exist_for_types?('index', [])).to be(false)
  end
end
