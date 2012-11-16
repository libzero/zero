module Zero
  class FileNotFoundError < IOError; end
  # This class helps with rendering of content.
  #
  # The purpose of this class is to render templates. All variables pushed into
  # the renderer should be already processed, so that the raw data can be used.
  #
  # The workflow of this class is like the following.
  #
  # * setup the type mapping
  # * create a new instance of the class to prepare rendering
  # * call #render to process the template
  #
  # The call to #render will return the String representation of the template
  # with all data given.
  class Renderer
    # set a base path for template search
    # @param path [String] the path to the template base dir
    def self.template_path=(path)
      @@path = path + '/'
    end

    # save a mapping hash for the type
    #
    # With that it is possible to map long and complex contant types to simpler
    # representations. These get then used in the finding process for the best
    # fitting template.
    #
    # @example
    #   Zero::Renderer.map = {'text/html' => 'html'}
    #
    # @param map [Hash] maps the content type to a simple representation
    def self.type_map=(map)
      @@map = map
    end

    # returns the type map
    # @return [Hash] the mapping for types
    def self.type_map
      @@map ||= {}
    end

    # take the path and render the template within the context
    # @param path [String] the relative path to the template
    # @param context [Object] the object to process on
    # @param accept_types
    def initialize(path, context, accept_types)
      accept_types ||= Request::Accept.new('text/html')
      @path    = find_template(path, accept_types)
      @context = context
    end

    # render the template within the context
    # @return [String] the rendered template
    def render
      Tilt.new(@path).render(@context)
    end

    private

    # check if the template does exist
    # @api private
    # @param template_path [String] the relative path to the template
    # @param types [Array] a sorted list of types to search for
    # @return [String] a file name to use
    def find_template(template_path, types)
      types.each do |type|
        Dir[@@path + template_path + '.' + transform(type) + '.*'].each do |file|
          return file
        end
      end
      raise FileNotFoundError.new("Template '#{template_path}' not found!")
    end

    # transform a type into a simpler representation
    # @api private
    # @param string [String] the original type name
    # @return [String] the shorter representation or the original
    def transform(string)
      return map[string] if map.has_key?(string)
      string
    end

    # an alias to Renderer.map
    # @api private
    def map
      self.class.map
    end
  end
end
