require "ostruct"
require_relative "share/paths"

module Hastings
  module FS
    module Net
      # Invalid mount
      class Invalid < StandardError; end

      # Inheritable shares class
      class Share
        class << self; attr_accessor :prefix, :type; end

        def initialize(path, username: nil, password: nil)
          @path     = validate!(path)
          @username = username
          @password = password
        end

        # @!group Attributes
        # @!attribute [r] path
        #   @return [String]
        # @!attribute [r] username
        #   @return [String]
        # @!attribute [r] password
        #   @return [String]
        attr_reader :path, :username, :password

        # @return [Symbol] eg: [:cifs]
        def type
          self.class.type.freeze
        end

        # @return [Symbol] eg: [:smb]
        def prefix
          self.class.prefix.freeze
        end

        include Paths
        # @!endgroup

        # The base_path of the share (eg: //myshare/folder)
        # @param other [Share]
        # @return [Boolean]
        def ==(other)
          base_path == other.base_path
        end

        # @!group Validation

        # Class method to check if it's a valid {Share}
        # @param path [String]
        # @return [Fixnum]
        def self.valid?(path)
          %r{^(#{prefix || ".+?"}:)?//} =~ path
        end

        private

          # Validate it's a valid path and strip the prefix
          # @param path [String]
          # @return [String] stripped path
          # @raise [Invalid]
          def validate!(path)
            self.class.valid?(path) && strip_prefix(path) ||
              fail(Invalid, [self.class.name[/[^:]+$/], path].join(": "))
          end

          # Strip the share prefix
          # @param path [String]
          # @return [String] stripped path
          def strip_prefix(path)
            path.sub(%r{^\w+:(//)}, '\1')
          end

        # @!endgroup
      end # Share
    end # Network
  end # FS
end # Hastings
