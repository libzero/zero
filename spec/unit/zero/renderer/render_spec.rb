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
    it 'renders the template' do
      expect(subject.render('index', html_types, binding)
            ).to match(/layoutfile[\n]*success/)
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
