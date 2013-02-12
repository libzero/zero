require 'spec_helper'

describe Zero::Renderer, '#render' do
  subject { Zero::Renderer.new(template_path, type_map) }
  let(:template_path) { 'spec/fixtures/templates/' }
  let(:type_map) {{
    'html' => ['text/html', 'text/xml', '*/*'],
    'json' => ['application/json', 'plain/text']
  }}
  let(:html_types) { ['text/html'] }
  let(:json_types) { ['application/json'] }
  let(:foo_types)  { ['foo/bar', 'bar/foo'] }
  let(:binding) { SpecTemplateContext.new('foo') }

  before :each do
    subject.read_template_path!
  end

  it 'returns a tilt template' do
    subject.render('index', html_types, binding).should be_kind_of(String)
  end

  it 'renders html content' do
    subject.render('index', html_types, binding).should match('success')
  end

  it 'returns a tilt template for different types' do
    subject.render('index', json_types, binding).should be_kind_of(String)
  end

  it 'renders json content' do
    subject.render('index', json_types, binding).should match("{text: 'success'}")
  end

  it 'returns an ArgumentError, if given template does not exist' do
    expect {
      subject.render('foobar', html_types, binding)
    }.to raise_error(ArgumentError, "No template found for 'foobar'!")
  end

  it 'returns an ArgumentError, if no template fits types' do
    expect {
      subject.render('index', foo_types, binding)
    }.to raise_error(
      ArgumentError,
      "No template found for any of this types #{foo_types.join ', '}!"
    )
  end

  it 'uses the context' do
    subject.render('context', html_types, binding).should match('foo')

  end
end
