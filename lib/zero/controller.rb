module Zero

  # abstract class to make creation of controllers easier
  #
  # This abstract class creates an interface to make it easier to write
  # rack compatible controllers. It catches #call and creates a new instance
  # with the environment and calls #render on it.
  class Controller
    def self << call(env)
      new(Request.new(env)).render
    end
  end
end
