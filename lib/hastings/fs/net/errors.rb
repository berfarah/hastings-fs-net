module Hastings
  module FS
    module Net
      class Error < StandardError; end
      class NotRegisteredError < Error; end
      class NotImplementedError < Error; end
      class InvalidError < Error; end
    end
  end
end
