require 'spec_helper'

describe Zero::Renderer::TemplateFinder, '#get' do
  subject { described_class.new(template_path, type_map) }
  let(:template_path) { 'spec/fixtures/templates/' }
  let(:type_map) {{
    'html' => ['text/html', 'text/xml', '*/*'],
    'json' => ['application/json', 'plain/text']
  }}
  let(:html_types) { ['text/html'] }
  let(:json_types) { ['application/json'] }
  let(:foo_types)  { ['foo/bar', 'bar/foo'] }

  it 'returns a Tilt template' do
    expect(subject.get('index', html_types)).to be_kind_of(Tilt::Template)
  end

  it 'raises an Error when the template is not found' do
    expect { subject.get('not_exist', html_types) }.to raise_error(
      ArgumentError, /Template 'not_exist' does not exist/)
  end

  it 'raises an Error when no type for the template was found' do
    expect { subject.get('index', foo_types) }.to raise_error(
      ArgumentError, /Template 'index' not found/)
  end
end
