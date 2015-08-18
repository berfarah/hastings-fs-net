require "hastings/core/shell"
require_relative "cli/arguments"

module Hastings
  module Mount
    # Command Line Interface for Mounts
    class Cli
      def initialize(settings)
        @args = Arguments.new(settings)
      end

      # @param path [String] share path
      # @param mounted_on [String] (optional) local path
      # @return [Boolean]
      def mounted?(path, mounted_on = nil)
        true & _mount("| grep '#{path}' | grep '#{mounted_on}'")
      rescue; false
      end

      # @param path [String] share path
      # @param mounted_on [String] local path
      # @return [String] STDOUT if success
      # @raise [Hastings::Shell::Error] if failure
      def mount(path, mounted_on)
        mkdir_p(mounted_on)
        _mount([@args.opts, path, mounted_on].join(" "))
      end

      # @param path [String] share path
      # @return [String] STDOUT if success
      # @raise [Hastings::Shell::Error] if failure
      def unmount(path)
        _umount(path)
      end

      private

        # Proxy for [Hastings::Shell#run]
        def run(*args)
          Shell.run(*args)
        end

        def mkdir_p(path)
          run("mkdir -p #{path}")
        end

        def _mount(args = nil)
          run(["mount", @args.type, args].compact.join(" "))
        end

        def _umount(args = nil)
          run(["umount", @args.type, args].compact.join(" "))
        end
    end # Cli
  end # Mount
end # Hastings
