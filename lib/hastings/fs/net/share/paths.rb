module Hastings
  module FS
    module Net
      # Operations on our remote path. Examples are done based on the example
      # [//my_share/first_path/second_path/third_path]
      module Paths
        # Base directory
        # @return [String] eg: [/my_share/first_path]
        def base_dirs
          split_dirs[0..1]
        end

        # Base path
        # @return [String] eg: [//my_share/first_path]
        def base_path
          ["/", *base_dirs].join("/")
        end

        # Local Directories
        # @return [String] eg: [/second_path/third_path]
        def local_dirs
          split_dirs[2..-1]
        end

        # Local base path
        # @return [String] eg: [{Hastings.root}/my_share/first_path]
        def local_base_path
          File.join Hastings.root, *base_dirs
        end

        # Local full path
        # @return [String] eg:
        #   [{Hastings.root}/my_share/first_path/second_path/third_path]
        def local_full_path
          File.join Hastings.root, *base_dirs, *local_dirs
        end

        private

          # Directory without initial //
          def split_dirs
            path[2..-1].split("/")
          end
      end
    end
  end
end
