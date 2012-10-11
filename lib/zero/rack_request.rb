# as we need #update_param we patch it it into the request
# this is directly from thr request.rb of the rack repository, so this
# can be deleted, when rack was released
r = Rack::Request.new(Rack::MockRequest.env_for('foo'))
if not r.respond_to?('update_param') then
  class Rack::Request
    # Destructively update a parameter, whether it's in GET and/or POST.
    # Returns nil.
    #
    # The parameter is updated wherever it was previous defined, so
    # GET, POST, or both. If it wasn't previously defined, it's inserted into GET.
    #
    # env['rack.input'] is not touched.
    def update_param(k, v)
      found = false
      if self.GET.has_key?(k)
        found = true
        self.GET[k] = v
      end
      if self.POST.has_key?(k)
        found = true
        self.POST[k] = v
      end
      unless found
        self.GET[k] = v
      end
      @params = nil
      nil
    end

    # Destructively delete a parameter, whether it's in GET or POST.
    # Returns the value of the deleted parameter.
    #
    # If the parameter is in both GET and POST, the POST value takes
    # precedence since that's how #params works.
    #
    # env['rack.input'] is not touched.
    def delete_param(k)
      v = [ self.POST.delete(k), self.GET.delete(k) ].compact.first
      @params = nil
      v
    end
  end
end
