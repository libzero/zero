require 'zero/renderer/template_finder'

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
      @template_path = template_path
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
      @templates = TemplateFinder.new(template_path, @type_map).get_templates
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
            # TODO Will be implemented later
            # return template if template.kind_of?(Tilt::Template)
            return Tilt.new(template)
          end
        end
        raise ArgumentError.new(
          "No template found for any of this types #{types.join ', '}!"
        )
      end
      raise ArgumentError.new "No template found for '#{name}'!"
    end
  end
end
