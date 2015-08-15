require "hastings/core/shell"

module Hastings
  module Mount
    # Command Line Interface for Mounts
    class Cli
      # Interpret data as arguments
      class Arguments
        def initialize(obj)
          @obj = obj
        end

        def type
          @obj.type && "-t #{@obj.type}"
        end

        def opts
          [auth, read_write_mode].compact.map { |e| "-o #{e}" }.join(" ")
        end

        private

          def read_write_mode
            @obj.read_only ? :ro : :rw
          end

          def auth
            return unless @obj.username && @obj.password
            "username='#{escape(@obj.username)}',"\
            "password='#{escape(@obj.password)}'".freeze
          end

          def escape(str)
            str.gsub(/'/, %(\'))
          end
      end # Arguments

      def initialize(settings)
        @args = Arguments.new(settings)
      end

      def mounted?(path, mounted_on = nil)
        true & _mount("| grep '#{path}' | grep '#{mounted_on}'")
      rescue; false
      end

      def mount(path, mounted_on)
        mkdir_p(mounted_on)
        _mount([@args.opts, path, mounted_on].join(" "))
      end

      def unmount(path)
        _umount(path)
      end

      private

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
