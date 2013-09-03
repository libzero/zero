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
    # @example create a simple renderer with a mapping from html to text/html
    #   Renderer.new('app/templates', {'html' => 'text/html'})
    #
    # @example create a renderer with a small map
    #   Renderer.new('app', {
    #     'html' => ['text/html', 'application/html+xml'],
    #     'json' => ['application/json', 'application/aweomse+json']
    #   })
    # @example create a renderer with a specific layout
    #   Renderer.new('app'. 'layouts/layout', {'html' => 'text/html'})
    #
    # @param path [String] the relative path to templates
    # @param layout [String] the key of the layouts
    # @param types [Hash{String => Array}] a map of short type names to long ones
    def initialize(path, layout = 'layout', types)
      @path   = path
      @layout = layout
      @types  = types
    end

    # returns the hash of type conversions
    # @return [Hash] type conversion
    attr_reader :types
    # returns the key for layout files
    # @return [String] the key for layouts
    attr_reader :layout
    # get the path to the templates
    # @return [String] the base template path
    attr_reader :path
    # get the tree of templates
    #
    # This function returns all templates with their keys.
    # @api private
    # @return [Hash] the template tree
    def templates
      @templates ||= TemplateFinder.new(path, types)
    end

    # render a template
    #
    # This method will render the template according to the requested types.
    # @param template [String] the template to render
    # @param types [Array<String>] a list of types requested to render
    # @param context [Object] any object to use for rendering
    # @return [String] the result of rendering
    def render(template, types, context)
      unless templates.exist_for_types?(layout, types)
        return render_partial(template, types, context)
      end
      load_layout_template(types).render(context) do
        render_partial(template, types, context)
      end
    end

    # render a template without layout
    #
    # This can be used to render a template without using a layout.
    # @param template [String] the template to render
    # @param types [Array<String>] a list of types requested to render
    # @param context [Object] any object to use for rendering
    # @return [String] the result of rendering
    def render_partial(template, types, context)
      templates.get(template, types).render(context)
    end

    private

    def load_layout_template(types)
      templates.get(layout, types)
    end
  end
end
