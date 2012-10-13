require 'spec_helper'

describe Zero::Router do
  let(:router) { Zero::Router.new(routes) }
  subject { router.call(env) }
#  let(:app) do
#    lambda {|env| [200, {'Content-Type' => 'text/html'}, 'correct'] }
#  end
  let(:app) { double }
  let(:wrong_app) do
    lambda {|env| [200, {'Content-Type' => 'text/html'}, 'Wrong'] }
  end

  before :each do
    app.should_receive(:call)
  end

  context 'it recognizes root' do
    let(:routes) { { '/' => app } }
    let(:env) { generate_env('/') }
    it('handles /') { subject }
  end

  context 'a working route' do
    let(:routes) { { '/app' => app } }
    let(:env) { generate_env('/app') }
    it('takes a route') { subject }
  end

  context 'select the right route' do
    let(:routes) do
      { '/wrong'   => wrong_app,
        '/correct' => app }
    end
    let(:env) { generate_env('/correct') }
    it("selects the correct from multiple routes") { subject }
  end

  context 'uses the deepest path' do
    let(:routes) { { '/wrong'        => wrong_app,
                     '/deep'         => wrong_app,
                     '/deep/wrong'   => wrong_app,
                     '/deep/correct' => app }} 
    let(:env) { generate_env('/deep/correct') }
    it("finds uses the deepest path first") { subject }
  end

  context 'converts parts of the url to parameters' do
    let(:routes) { { '/foo/:id' => app } }
    let(:env) { generate_env('/foo/42') }
    it "should extract variables from the url" do
      subject
    end
  end
end
