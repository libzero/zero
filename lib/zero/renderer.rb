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
    # @param template_path [String] a string to templates
    # @param type_map [Hash] a map of simple types to complex ones
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
    # @return [Self] returns the object
    def read_template_path!
      @templates = Hash.new do |hash, key|
        # TODO this is just ugly
        result = []
        search_files(key).each { |file| fill_template_type_map(result, file) }
        Hash[result]
      end
      self
    end

    private

    # search in `template_path` for templates beginning with `template_name`
    # @api private
    # @param template_name [String] the name of the template
    # @return [#each] a list of all templates found
    def search_files(template_name)
      Dir[template_path + template_name + '**/*.*']
    end

    # fill the `datamap` with all variants of files and types found
    # @api private
    # @param dataset [Hash] the hash to fill with values
    # @param file [String] a filename which will be used to fill the hash
    def fill_template_type_map(dataset, file)
      parts = file.split('.')
      read_type(parts[2]).each do |type|
        dataset << [type, file]
      end
    end

    # gets the type information from a file and converts it to an array of
    # possible matching types
    # @api private
    # @param short_notation [String] a short notation of a type, like `html`
    # @return [Array] a list of matching types, like `text/html`
    def read_type(short_notation)
      to_type_list(type_map[short_notation] || short_notation)
    end

    # convert a map to an array if it is not one
    # @api private
    # @param original_map [Object] the type(s) to convert
    # @return [Array] a list of objects
    def to_type_list(original_map)
      return original_map if original_map.respond_to?(:each)
      [original_map]
    end
  end
end
