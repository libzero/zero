require 'spec_helper'

describe Zero::Router, '#call' do
  subject { Zero::Router.new(routes) }
  let(:result) { ['success'] }
  let(:content_type) { {'Content-Type' => 'text/html'} }
  let(:status_code) { 200 }

  let(:wrong_app) do
    lambda {|env| [200, {'Content-Type' => 'text/html'}, 'Wrong'] }
  end
  let(:app) { SpecApp }

  shared_examples_for 'a sample app' do
    it "returns a response" do
      subject.call(env).to_a[0].should eq(status_code)
      subject.call(env).to_a[1].should eq(content_type)
      subject.call(env).to_a[2].should eq(result)
    end
  end

  context 'with a single route' do
    let(:routes) {{ '/' => app }}
    let(:env) { EnvGenerator.get('/') }
    it_behaves_like "a sample app"
  end

  context 'with empty path' do
    let(:routes) {{ '' => wrong_app, '/welcome' => app }}
    let(:env) { EnvGenerator.get('/welcome') }

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

  context 'with nested variable routes' do
    let(:routes) do
      { '/' => wrong_app, '/foo/:id' => app, '/foo/:id/bar' => wrong_app }
    end
    let(:env) { EnvGenerator.get('/foo/23') }
    it_behaves_like "a sample app"
  end

  context 'with nested routes and variable in the middle' do
    let(:routes) do
      { '/' => wrong_app, '/foo/:id' => wrong_app, '/foo/:id/bar' => app }
    end
    let(:env) { EnvGenerator.get('/foo/23/bar') }
    it_behaves_like "a sample app"
  end

  context 'with a route not found' do
    let(:routes) {{ '/foo' => wrong_app, '/foo/bar/baz' => app }}
    let(:env) { EnvGenerator.get('/foo/bar') }
    let(:result) { ['Not found!'] }
    let(:status_code) { 404 }
    it_behaves_like "a sample app"
  end

  context 'with empty route' do
    let(:routes) {{ '' => wrong_app }}
    let(:env) { EnvGenerator.get('/foo') }
    let(:result) { ['Not found!'] }
    let(:status_code) { 404 }
    it_behaves_like "a sample app"
  end

  context 'with parameters' do
    let(:routes) {{ '/foo/:id' => app }}
    let(:env) { EnvGenerator.get('/foo/bar') }
    let(:app) do
      lambda do |env|
        [200, content_type, [Zero::Request.new(env).params['id']]]
      end
    end
    let(:result) { ['bar'] }

    it_behaves_like 'a sample app'
  end

  context 'with parameters and nested routes' do
    let(:routes) do
      { '/' => wrong_app, '/foo/:id' => app, '/foo/:id/bar' => wrong_app }
    end
    let(:env) { EnvGenerator.get('/foo/bar') }
    let(:app) do
      lambda do |env|
        [200, content_type, [Zero::Request.new(env).params['id']]]
      end
    end
    let(:result) { ['bar'] }

    it_behaves_like "a sample app"
  end

  context 'with a dash in the variable' do
    let(:routes) { {'/:id' => app} }
    let(:env) { EnvGenerator.get('/foo-bar') }
    let(:app) do
      lambda do |env|
        [200, content_type, [Zero::Request.new(env).params['id']]]
      end
    end
    let(:result) { ['foo-bar'] }

    it_behaves_like "a sample app"
  end
end
