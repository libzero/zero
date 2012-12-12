require 'spec_helper'

describe Zero::Router, '#call' do
  subject { Zero::Router.new(routes) }
  let(:result) { ['success'] }

  let(:wrong_app) do
    lambda {|env| [200, {'Content-Type' => 'text/html'}, 'Wrong'] }
  end
  let(:app) { SpecApp }

  shared_examples_for 'a sample app' do
    it "returns a response" do
      subject.call(env).to_a[2].should eq(result)
    end
  end

  context 'with a single route' do
    let(:routes) {{ '/' => app }}
    let(:env) { EnvGenerator.get('/') }
    it_behaves_like "a sample app"
  end

  context 'with multiple router' do
    let(:routes) {{ '/foo' => app, '/wrong' => wrong_app }}
    let(:env) { EnvGenerator.get('/foo') }
    it_behaves_like "a sample app"
  end

  context 'with nested routes' do
    let(:routes) {{ '/' => wrong_app, '/foo' => app, '/foo/bar' => wrong_app }}
    let(:env) { EnvGenerator.get('/foo') }
    it_behaves_like "a sample app"
  end

  context 'with a route not found' do
    let(:routes) {{ '/foo' => wrong_app, '/foo/bar/baz' => app }}
    let(:env) { EnvGenerator.get('/foo/bar') }
    let(:result) { ['Not found!'] }
    it_behaves_like "a sample app"
  end

  context 'with parameters' do
    let(:routes) {{ '/foo/:id' => app }}
    let(:env) { EnvGenerator.get('/foo/bar') }
    let(:app) do
      lambda do |env|
        [200, {}, [Zero::Request.new(env).params['id']]]
      end
    end
    let(:result) { ['bar'] }

    it_behaves_like 'a sample app'
  end
end
