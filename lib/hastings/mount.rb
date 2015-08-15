require_relative "mount/proxy_dir"
require_relative "mount/registry"
require_relative "mount/share"
require "ostruct"

module Hastings
  # Mount class
  module Mount
    # Cifs shares
    class Cifs < Share
      self.prefix = :cifs
      self.type   = :cifs
    end

    # Samba shares
    class Samba < Cifs
      self.prefix = :smb
    end

    # Singleton methods
    class << self
      def mount?(path)
        case path
        when %r{^smb://}     then Samba
        when %r{^(cifs:)?//} then Cifs
        else false
        end
      end

      def registry
        @registry ||= Registry.new
      end

      def settings(username: nil, password: nil, read_only: false)
        OpenStruct.new username: username,
                       password: password,
                       read_only: read_only
      end

      def mount!(path, settings)
        ProxyDir.new new_mount(path, settings).tap { |m| registry.add m }
      end

      def unmount!(path, settings)
        registry.remove new_mount(path, settings)
      end

      private

        def new_mount(path, settings)
          klass = mount?(path) || fail(Invalid)
          klass.new(path, settings)
        end
    end
  end
end
