require 'spec_helper'

describe Zero::Renderer::TemplateFinder, '#exist?' do
  subject { described_class.new(template_path, type_map) }
  let(:template_path) { 'spec/fixtures/templates/' }
  let(:type_map) { {'html' => 'text/html'} }

  it 'returns true when the template exists' do
    expect(subject.exist?('index')).to be(true)
  end

  it 'returns false when the template does not exist' do
    expect(subject.exist?('not_found')).to be(false)
  end
end
