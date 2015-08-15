require "hastings/dir"

module Hastings
  module Mount
    # Proxy for mounted directories
    class ProxyDir < Dir
      attr_reader :share, :remote_path

      def initialize(share)
        @remote_path = share.path
        @share       = share
        super(share.local_full_path)
      end
    end
  end
end
