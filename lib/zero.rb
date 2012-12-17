if RUBY_VERSION <= '1.9'
  require 'backports'
end

module Zero
  require 'zero/controller'
  require 'zero/router'
  require 'zero/renderer'
  require 'zero/request'
  require 'zero/response'
end
