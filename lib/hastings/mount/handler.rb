require "ostruct"
require "hastings/mount/proxy_dir"
require "hastings/mount/registry"
Dir[File.expand_path("../types/*", __FILE__)].each(&method(:require))

module Hastings
  module Mount
    # Handler routes mounts to the right class
    module Handler
      # Checks if the mount type has been implemented
      # @param path [String] Validates if the string is a network drive url
      # @return [Share] returns the class of mount that it is
      # @raise [NotImplementedError] fails if the url hasn't been implemented
      def mount?(path)
        Share.descendants.find { |s| s.valid?(path) && s } ||
          fail(NotImplementedError)
      end

      # @return [Registry]
      def registry
        @registry ||= Registry.new
      end

      # Sends the share to the registry to be mounted
      # @param path [String] path to share
      # @param args [Hash] passes these on to create an OpenStruct which only
      #   accepts username, password and read_only
      # @return [ProxyDir]
      def mount!(path, **args)
        klass = mount?(path)
        share = klass.new(path, settings(**args))
        registry.add(share)
        ProxyDir.new(share)
      end

      # Unmounts the path from the registry
      # @param path [String] path to share
      # @return [Share] unmounted path
      def unmount!(path)
        klass = mount?(path)
        share = klass.new(path, settings)
        registry.remove(share)
      end

      private

        def settings(username: nil, password: nil, read_only: false)
          OpenStruct.new username: username, password: password,
                         read_only: read_only
        end
    end
  end
end
