module Zero
  class FileNotFoundError < IOError; end
  class Renderer
    # set the path to the template base directory
    def self.template_path(path)
      @@path = path + '/'
    end

    # take the path and render the template within the context
    def initialize(path, context, accept_types)
      accept_types ||= Request::Accept.new('text/html')
      @path    = find_template(path, accept_types)
      @context = context
    end

    # check if the template does exist
    def find_template(template_path, types)
      types.each do |type|
        Dir[@@path + template_path + '.' + type + '.*'].each do |file|
          return file
        end
      end
      raise FileNotFoundError.new("Template '#{template_path}' not found!")
    end

    # render the template within the context
    def render
      Tilt.new(@path).render(@context)
    end
  end
end
