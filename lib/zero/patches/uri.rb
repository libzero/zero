module URI

    # Gets a query string and splits it into its key value pairs.
    # If URI already supports this functionality (decode_www_form on Ruby 1.9+),
    # it will use this. Else it will run an onw implementation, without any
    # encoding functionality.
    #
    # @param [String] query The query string
    # @return [Array] Parsed query
    #
    def self.parse_query_string(query)
      # Call the original decode_www_form method on ruby 1.9+
      if URI::respond_to? 'decode_www_form'
        return self.decode_www_form query
      end

      # else split the query self
      return self.decode_www_form_18 query
    end


    # Own implementation of decode_www_form.
    # Shall behave almost like the original method, but without any encoding
    # stuff.
    #
    # @param [String] query The query string
    # @return [Array] Parsed query
    #
    def self.decode_www_form_18(query)
      return [] if query.empty?
      unless query.match '='
        raise ArgumentError,
          "invalid data of application/x-www-form-urlencoded (#{query})"
      end
      parsed = []
      # breakes the string at & and ;
      query.split(/[&;]/).each do |query_part|
        # breakes the string parts at =
        key, value = query_part.split('=')

        # make an empty string out of value, if it's nil
        value = '' if value.nil?
        # append the key value pair on the result array
        parsed << [
          decode_www_form_component_18(key),
          decode_www_form_component_18(value)
        ]
      end
      # return result array
      return parsed
    end

    TBLDECWWWCOMP18_ = {}

    # Own implementation of decode_www_form_component.
    # Shall behave almost like the original method, but without any encoding
    # stuff.
    #
    # @param [String] string 
    # @return [String]
    #
    def self.decode_www_form_component_18(string) 
      # Fill table for URI special chars
      if TBLDECWWWCOMP18_.empty?
        tbl = {}
        256.times do |i|
          h, l = i>>4, i&15
          tbl['%%%X%X' % [h, l]] = i.chr
          tbl['%%%x%X' % [h, l]] = i.chr
          tbl['%%%X%x' % [h, l]] = i.chr
          tbl['%%%x%x' % [h, l]] = i.chr
        end
        tbl['+'] = ' '
        begin
          TBLDECWWWCOMP18_.replace(tbl)
          TBLDECWWWCOMP18_.freeze
        rescue
        end
      end
      # unless /\A[^%]*(?:%\h\h[^%]*)*\z/ =~ str
      #   raise ArgumentError, "invalid %-encoding (#{str})"
      # end

      # Replace URI special chars
      string.gsub(/\+|%[a-zA-Z0-9]{2}/) do |sub_string|
        TBLDECWWWCOMP18_[sub_string]
      end
    end

end
