require 'spec_helper'

describe Zero::Request::Parameter, '#initialize' do
  subject { Zero::Request::Parameter.new(env) }
  let(:env) { EnvGenerator.get('/get', {
    'zero.params.custom' => {'foo' => 'bar'} }) }

  it 'does not overwrite parameters' do
    subject
    expect(env['zero.params.custom']).to have_key('foo')
  end
end
