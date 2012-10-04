module Zero
  class Server
    def call(env)
      [200, {'Content-Type' => 'text/html'}, ["Hello World!"]]
    end
  end
end
