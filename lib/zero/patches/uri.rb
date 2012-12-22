module URI

    # Gets a query string and splits it into its key value pairs.
    # If URI already supports this functionality (decode_www_form on Ruby 1.9+),
    # it will use this. Else ... nothing at the moment.
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
        # append the key value pair on the result array
        parsed << [key, value]
      end
      # return result array
      return parsed
    end

=begin
    WFKV_ = '(?:[^%#=;&]*(?:%\h\h[^%#=;&]*)*)'

    def self.decode_www_form(str, enc= nil)
      return [] if str.empty?
      unless /\A#{WFKV_}=#{WFKV_}(?:[;&]#{WFKV_}=#{WFKV_})*\z/ =~ str
        raise ArgumentError,
          "invalid data of application/x-www-form-urlencoded (#{str})"
      end
      ary = []
      $&.scan(/([^=;&]+)=([^;&]*)/) do
        ary << [
          decode_www_form_component($1, enc),
          decode_www_form_component($2, enc)
        ]
      end
      ary
    end

    def self.decode_www_form_component(str, enc= nil)
      raise ArgumentError, "invalid %-encoding (#{str})" unless /\A[^%]*(?:%\h\h[^%]*)*\z/ =~ str
      str.gsub(/\+|%\h\h/, TBLDECWWWCOMP_).force_encoding(enc)
    end
=end

end
