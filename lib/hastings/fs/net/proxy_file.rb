require "hastings/fs/file"

module Hastings
  module FS
    module Net
      # Proxy for mounted directories
      class ProxyFile < File
        attr_reader :share, :remote_path

        def initialize(share)
          @remote_path = share.path
          @share       = share
          super(share.local_full_path)
        end
      end
    end
  end
end
