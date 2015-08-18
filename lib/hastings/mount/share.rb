require_relative "share/paths"
require_relative "share/cli"

module Hastings
  module Mount
    # All mount errors
    class Error < StandardError; end
    # Unable to mount
    class NoMount < Error; end
    # Unable to unmount
    class Busy < Error; end
    # Invalid mount
    class Invalid < Error; end

    # Inheritable shares class
    class Share
      class << self; attr_accessor :prefix, :type; end

      def initialize(path, settings)
        @path = validate!(path)

        # CLI setup
        settings.type = self.class.type
        @cli  = Cli.new(settings)
      end

      # @!group Attributes
      # @!attribute [r] cli
      #   @return [Cli]
      # @!attribute [r] path
      #   @return [String]
      attr_reader :cli, :path
      include Paths
      # @!endgroup

      # Check if the share is mounted
      # @return [Boolean]
      def mounted?
        cli.mounted?(path, local_base_path)
      end

      # The base_path of the share (eg: //myshare/folder)
      # @param other [Share]
      # @return [Boolean]
      def ==(other)
        base_path == other.base_path
      end

      # @!group Actions

      # Mount the share, tries 3 times
      # @return [Boolean]
      def mount
        tries(3, rescue_from: Shell::Error) { cli.mount(path, local_base_path) }
      end

      # Unmount the share, tries 3 times
      # @return [Boolean]
      def unmount
        tries(3, rescue_from: Shell::Error) { cli.unmount(path) }
      end

      # Mount the share, fail if it isn't able to
      # @return [Boolean]
      # @raise [NoMount]
      def mount!
        mount || fail(NoMount, "#{class_name} share: #{path}")
      end

      # Unmount the share, fail if it isn't able to
      # @return [Boolean]
      # @raise [Busy]
      def unmount!
        unmount || fail(Busy, "#{class_name} share: #{path}")
      end

      # @!endgroup

      private

        # Class name (eg: Share)
        def class_name
          self.class.name[/[^:]+$/]
        end

        # Shorthand for retries
        def tries(retries, rescue_from: StandardError, &block)
          tries ||= retries
          block.call
          true
        rescue rescue_from
          (tries -= 1).zero? ? false : retry
        end

        # @!group Validation

        # Class method to check if it's a valid {Share}
        # @param path [String]
        # @return [Fixnum]
        def self.valid?(path)
          %r{^(#{prefix || ".+?"}:)?//} =~ path
        end

        # Validate it's a valid path and strip the prefix
        # @param path [String]
        # @return [String] stripped path
        # @raise [Invalid]
        def validate!(path)
          self.class.valid?(path) && strip_prefix(path) ||
            fail(Invalid, [self.class.name.split(":").last, path].join(": "))
        end

        # Strip the share prefix
        # @param path [String]
        # @return [String] stripped path
        def strip_prefix(path)
          path.sub(%r{^\w+:(//)}, '\1')
        end

      # @!endgroup
    end
  end
end
