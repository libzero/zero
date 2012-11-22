require 'spec_helper'

describe Zero::Renderer, '#template_path' do
  subject { Zero::Renderer.new(template_path) }
  let(:template_path) { 'foo' }

  its(:type_map) { should be(template_path) }
end
