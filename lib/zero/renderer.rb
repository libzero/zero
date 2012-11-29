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
      # TODO clean up later
      @templates = {}
      search_files.each do |file|
        parts = file.gsub(/#{template_path}/, '').split('.')
        @templates[parts[0]] ||= {}

        # Set default value
        types = 'default'
        # Overwrite default value, if it's set in template path
        if parts.count > 2 then
          types = parts[1]
        end

        read_type(types).each do |type|
          @templates[parts[0]][type] = file
        end
      end
    end

    # render a template
    #
    # This method will render the given template, based on the type in the given
    # context.
    # @param name [String] the name of the template
    # @param type [Array] a list of accept types used to find the template
    # @param context [Object] the context in which to evaluate the template
    # @return [String] the rendered content
    def render(name, type, context)
      template(name, type).render(context)
    end

    private

    # search in `template_path` for templates beginning with `template_name`
    # @api private
    # @param template_name [String] the name of the template
    # @return [#each] a list of all templates found
    def search_files
      Dir[template_path + '**/*.*']
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

    # get the prepared template for the name and type
    # @api private
    # @param name [String] the name of the template
    # @param types [Array] the types for the template
    # @return [Tilt::Template] a prepared tilt template
    def template(name, types)
      if templates.has_key? name
        types.each do |type|
          template = templates[name][type]
          unless template.nil?
            return template if template.kind_of?(Tilt::Template)
            return Tilt.new(template)
          end
        end
      end
      raise ArgumentError.new "No template found for '#{name}'!"
    end
  end
end
