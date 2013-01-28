# Only add fixes, if needed to avoid an unnecessary installed gem
if RUBY_VERSION <= '1.9'
  require 'zero_fix18'
end

require 'class_options'

module Zero
  require 'zero/controller'
  require 'zero/router'
  require 'zero/renderer'
  require 'zero/request'
  require 'zero/response'
end
