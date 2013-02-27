require 'spec_helper'

describe Zero::Renderer, '#render' do
  subject { described_class.new(template_path, type_map) }
  let(:template_path) { 'spec/fixtures/templates/' }
  let(:type_map) {{
    'html' => ['text/html', 'text/xml', '*/*'],
    'json' => ['application/json', 'plain/text']
  }}
  let(:html_types) { ['text/html'] }
  let(:json_types) { ['application/json'] }
  let(:foo_types)  { ['foo/bar', 'bar/foo'] }
  let(:binding) { SpecTemplateContext.new('foo') }

  context 'with default layout' do
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
      }.to raise_error(ArgumentError, /Template 'foobar' does not exist/)
    end

    it 'returns an ArgumentError, if no template fits types' do
      expect {
        subject.render('index', foo_types, binding)
      }.to raise_error(
        ArgumentError, /Template 'index' not found/)
    end

    it 'uses the context' do
      subject.render('context', html_types, binding).should match('foo')

    end
  end

  context 'with special layout' do
    subject { described_class.new(template_path, layout, type_map) }
    let(:layout) { 'special_layout' }

    it 'uses the layout for rendering' do
      expect(subject.render('index', html_types, binding)
            ).to match(/layout loaded/)
    end

    it 'renders the template into the layout' do
      expect(subject.render('index', html_types, binding)
            ).to match(/success/)
    end
  end
end
