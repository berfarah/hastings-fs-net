module Hastings
  module Mount
    # Operations on our remote path
    module Paths
      # Useful for distinguishing what has already been mounted
      def base_dirs
        split_dirs[0..1]
      end

      def base_path
        ["/", *base_dirs].join("/")
      end

      def local_dirs
        split_dirs[2..-1]
      end

      def local_base_path
        File.join Hastings.pwd, *base_dirs
      end

      def local_full_path
        File.join Hastings.pwd, *base_dirs, *local_dirs
      end

      private

        def split_dirs
          path[2..-1].split("/")
        end
    end
  end
end
