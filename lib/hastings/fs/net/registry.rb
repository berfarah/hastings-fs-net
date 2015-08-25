module Hastings
  module FS
    module Net
      # A place to keep all of our shar
      class Registry
        attr_reader :shares

        def initialize
          @shares = []
        end

        # Registers the share if it doesn't exist
        # @param share [Share]
        # @return [Share]
        def add(share)
          return added?(share) if added?(share)
          shares << share
        end

        # Check to see if a share exists in the registry
        # @param share [Share]
        # @return [Share]
        def added?(share)
          shares.find { |s| s == share }
        end

        # Removes a share / equals share from the registry
        # @param share [Share]
        # @return [Share]
        def remove(share)
          shares.delete added?(share)
        end
      end # Registry
    end # Net
  end # FS
end # Hastings
