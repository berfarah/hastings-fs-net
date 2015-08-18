module Hastings
  module Mount
    class Cli
      # Interpret data as arguments
      class Arguments
        def initialize(obj)
          @obj = obj
        end

        # @return [String] arguments for Mount CLI type
        def type
          @obj.type && "-t #{@obj.type}"
        end

        # @return [String] arguments for Mount CLI opts
        def opts
          [auth, read_write_mode].compact.map { |e| "-o #{e}" }.join(" ")
        end

        private

          # Interprets boolean into options
          def read_write_mode
            @obj.read_only ? :ro : :rw
          end

          # Auth options into valid format
          def auth
            return unless @obj.username && @obj.password
            "username='#{escape(@obj.username)}',"\
            "password='#{escape(@obj.password)}'".freeze
          end

          # Escape single quotes for the shell
          def escape(str)
            str.gsub(/'/, %(\'))
          end
      end # Arguments
    end # Cli
  end # Mount
end # Hastings
