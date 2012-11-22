module Zero
  # the base renderer for getting render containers
  #
  # This class handles templates and render coontainers, which can be used for
  # the actual rendering.
  #
  # To use this renderer you have to give it a template path and optionally
  # a map of shorthand type descriptions to fully types. This will then be used
  # to extend the internal map of templates to possible formats in a way, that
  # you will be able to answer xhtml and html requests with the same template.
  #
  # When the object is initialized and you are sure, everything is loaded, call
  # #read_template_path! and the template tree will be built. Without this step,
  # you will probably don't get any output.
  #
  # After the setup, the renderer can be used to build render containers, which
  # then can be used to actually render something.
  class Renderer
    # initializes a new Renderer
    #
    # This method takes a path to the base template directory and a type map.
    # This type map is used to extend the possible renderings for different
    # types, which the clients sends.
    #
    # @example create a simple renderer
    #   Renderer.new('app/templates')
    #
    # @example create a renderer with a small map
    #   Renderer.new('app', {
    #     'html' => ['text/html', 'application/html+xml'],
    #     'json' => ['application/json', 'application/aweomse+json']
    #   })
    #
    # @param [String] a string to templates
    def initialize(template_path, type_map = {})
      @template_path = template_path + '/'
      @type_map = type_map
    end

    # returns the hash of type conversions
    # @return [Hash] type conversion
    attr_reader :type_map
    # get the path to the templates
    # @return [String] the base template path
    attr_reader :template_path
    # get the tree of templates
    # @api private
    # @return [Hash] the template tree
    attr_reader :templates

    # load the template tree
    #
    # This method gets all templates in the `template_path` and builds an
    # internal tree structure, where templates and types direct the request to
    # the wanted template.
    def read_template_path!
      @templates = Hash.new do |hash, key|
        subtree = {}
        search_files(key).each do |file|
          parts = file.split('.')
          read_type(parts[2]).each do |type|
            subtree[type] = file
          end
        end
        hash[key] = subtree
      end
      self
    end

    private

    def search_files(template_name)
      Dir[template_path + template_name + '**/*.*']
    end

    def read_type(short_notation)
      to_type_list(type_map[short_notation] || short_notation)
    end

    def to_type_list(original_map)
      return original_map if original_map.respond_to?(:each)
      [original_map]
    end
  end
end
