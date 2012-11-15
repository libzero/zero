module Zero
  class Request
    # encapsulates the accept header to easier work with
    # this is partly copied from sinatra
    class Accept
      MEDIA_TYPE_SEPERATOR  = ','
      MEDIA_PARAM_SEPERATOR = ';'
      MEDIA_QUALITY_REGEX   = /q=[01]\./

      def self.map=(map)
        @@map = map
      end

      def self.map
        @@map ||= {}
      end

      # create a new accept object
      def initialize(accept_string)
        if accept_string.nil?
          @types = []
        else
          @types = parse_media_types(accept_string)
        end
      end

      # return the preferred type
      # @return String the preferred media type
      def preferred
        @types.first
      end

      # iterate over all media types
      def each
        @types.each {|type| yield type}
      end

      private

      # converts the accept string to a useable array
      # @param accept_string the string containing media ranges and options
      def parse_media_types(accept_string = '*/*')
        accept_string.
          gsub(/\s/, '').
          split(MEDIA_TYPE_SEPERATOR).
          map do |accept_range|
           extract_order(*accept_range.split(MEDIA_PARAM_SEPERATOR))
          end.
          sort_by(&:last).
          map(&:first)
      end

      # extract the order of the type
      # @param media_type the type itself
      # @param params further options to the type
      # @return Array the media type and quality in that order
      def extract_order(media_type, *params)
        params.each do |param|
          if param.match(MEDIA_QUALITY_REGEX)
            return [map_type(media_type), 10 - param[4..-1].to_i] 
          end
        end
        [map_type(media_type), 0]
      end

      # map media types to the type given in the map
      # @param type [String] the media type
      # @return the media type of the mapping or the original
      def map_type(type)
        return map[type] if map.has_key?(type)
        type
      end

      # a small wrapper to the class method
      def map
        self.class.map
      end
    end
  end
end
