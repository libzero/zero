module Zero
  class Request
    # This class provides an interface to access information of accept schemas.
    class AcceptType
      MEDIA_TYPE_SEPERATOR  = ','
      MEDIA_PARAM_SEPERATOR = ';'
      MEDIA_QUALITY_REGEX   = /q=[01]\./

      # create a new instance of AcceptType
      def initialize(string)
        if string.nil?
          @elements = []
        else
          @elements = parse_elements(string)
        end
      end

      # return the preferred type
      # @return String the preferred media type
      def preferred
        @elements.first
      end

      # iterate over all media types
      def each
        @elements.each {|element| yield element}
      end

      private

      # converts the accept string to a useable array
      # @param string the string containing media ranges and options
      def parse_elements(string = '*/*')
        string.
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
            return [media_type, 10 - param[4..-1].to_i] 
          end
        end
        [media_type, 0]
      end
    end
  end
end
