module Zero
  class Renderer
    # finds templates in a path and builds a map for the renderer to use
    #
    # When this class is feeded with a path and a type map it will generate
    # a map of templates and types for the renderer to use.
    # For that to work, it first needs a path ending on '/' and a map of type
    # names to mime types. The short type name is used in template names to find
    # out, for which mime types they are built, so that they can be rendered
    # for the correct request.
    #
    # The template files can be named in two different formats
    # * filename.extension
    # * filename.type.extension
    # The type is used to access the `type_map`. It will be used to find all
    # mime types this template can be used to answer. If no type is given in the
    # filename, the type will be set to `default`.
    # So `default` can be used in the `type_map` to map these files too.
    #
    # @example building a TemplateFinder
    # As an example, lets assume we have the following files in our path
    # * `index.erb`
    # * `index.json.erb`
    #
    # We want these to render for either html requests or json requests. To make
    # this work, we need to build a TemplateFinder like following
    #
    #     TemplateFinder.new('path/', {
    #       'default' => ['text/html', '*/*'],
    #       'json'    => ['application/json']
    #     })
    #
    # This will build a structure, so that requests with 'text/html' will render
    # `index.erb`.
    class TemplateFinder
      # the search mask to search for files
      # @example foo/bar/**/*.*
      MARK_ALL_FILES = '**/*.*'
      # for finding the last slash
      SLASH_END    = '/'
      # empty string to replace the path in the filename
      EMPTY_STRING = ''
      # split filename at this character
      SPLIT_CHAR   = '.'
      # default type
      DEFAULT_TYPE = 'default'

      # the path to all templates
      # @api private
      # @returns [String] the path given at initialization
      attr_reader :path

      # a map of simple type names to a list of mime types
      # @api private
      # @example 'html' => ['text/html', 'text/xml', 'text/html+xml']
      # @returns [Hash] a hash with types to mime types
      attr_reader :type_map

      # this returns the regex for the specified path
      # @api private
      # @returns [Regex] the regex built from the path
      attr_reader :path_regex

      # initialize a new template finder
      #
      # @example
      #   TemplateFinder.new('foo/bar/', {
      #     'default' => ['text/html', 'text/xml'],
      #     'json' => ['application/json']
      #   })
      # @param path [String] the path to all templates ending on '/'
      # @param type_map [Hash] a map of short type names to mime types
      def initialize(path, type_map)
        raise ArgumentError.new("Has to end on '/'!") if path[-1] != SLASH_END
        @path = path
        @type_map  = sanity_map(type_map)
        @path_regex = /#{path}/
      end

      # traverses the template path to gather all templates
      #
      # This function traverses the template path, collects and sorts all
      # templates into the target types given at initialization.
      # @return [Hash] the map of type to template
      def get_templates
        result = Hash.new {|hash, key| hash[key] = {} }

        search_files.each do |file|
          key, value = add_template(file)
          result[key] = result[key].merge(value)
        end
        result
      end

      private

      # returns a list of files found at @path
      #
      # This method returns all files found in @path, which look like a template.
      # Look for `MARK_ALL_FILES` for the eact schema.
      # @api private
      # @return [Array] a list of all files found
      def search_files
        Dir[@path + MARK_ALL_FILES]
      end

      # splits the path into a filename and its type
      #
      # This function takes a filepath and extracts the filename and short
      # notation for the type.
      # The filename is later used at rendering time to find the template.
      # @api private
      # @param filepath [String] the filename to split
      # @return [Array] an Array of the following example `[filename, type]`
      def get_fields(filepath)
        filename, *options = filepath.gsub(@path_regex, EMPTY_STRING).split(SPLIT_CHAR)
        [filename, (options.length == 1 ? DEFAULT_TYPE : options[0])]
      end

      # add a template with its type variants
      #
      # This method adds a template with all type variants to the map of all
      # types and templates.
      # @api private
      # @param filename [String] the short name of the template
      # @param type [String] the short type of the template
      # @param path [String] the actual path to the template
      # @return [Array] a hashable array for the end result:
      def add_template(path)
        filename, type = get_fields(path)
        result = [filename, {}]
        get_types(type).each do |mime_type|
          result[1][mime_type] = path
        end
        result
      end

      # get the types for the shorthand type
      #
      # This method returns all types associated with the short notation
      # of this type in the type_map.
      # @api private
      # @param short_type [String] the short notation of a type
      # @return [Array] a list of all types found in the type_map
      def get_types(short_type)
        return [short_type] unless @type_map.has_key?(short_type)
        @type_map[short_type]
      end

      # make a cleanup of the map
      #
      # This function converts all map values to arrays, to make the processing
      # easier.
      # @api private
      # @param map [Hash] a type map
      # @return [Hash] the cleaned up map
      def sanity_map(map)
        map.each do |key, value|
          map[key] = [value] unless value.respond_to?(:each)
        end
      end
    end
  end
end
