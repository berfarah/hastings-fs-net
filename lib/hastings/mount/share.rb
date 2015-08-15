require_relative "paths"
require_relative "cli"

module Hastings
  module Mount
    class Error < StandardError; end
    class NoMount < Error; end
    class Busy < Error; end
    class Invalid < Error; end

    # Basic template for shares
    class Share
      class << self; attr_accessor :prefix, :type; end

      def initialize(path, settings)
        @path = validate!(path)

        # CLI setup
        settings.type = self.class.type
        @cli  = Cli.new(settings)
      end

      def ==(other)
        base_path == other.base_path
      end

      ##
      # Attributes
      attr_reader :cli, :path, :password, :username, :read_mode, :remote_path

      include Paths

      def mounted?
        cli.mounted?(path, local_base_path)
      end

      ##
      # Actions
      def mount
        tries(3, rescue_from: Shell::Error) { cli.mount(path, local_base_path) }
      end

      def unmount
        tries(3, rescue_from: Shell::Error) { cli.unmount(path) }
      end

      def mount!
        mount || fail(NoMount)
      end

      def unmount!
        unmount || fail(Busy)
      end

      private

        def tries(retries, rescue_from: StandardError, &block)
          tries ||= retries
          block.call
        rescue rescue_from
          (tries -= 1).zero? ? false : retry
        end

        ##
        # For initial validation
        def validate!(path)
          valid?(path) && strip(path) ||
            fail(Invalid, [self.class.name.split(":").last, path].join(": "))
        end

        def valid?(path)
          %r{^(#{self.class.prefix || ".+?"}:)?//} =~ path
        end

        def strip(path)
          path.sub(%r{^\w+:(//)}, '\1')
        end
    end
  end
end
