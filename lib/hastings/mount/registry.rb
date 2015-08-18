module Hastings
  module Mount
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
        share.mounted? || share.mount!
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
        s = added?(share)
        s.unmount!
        shares.delete(s)
      end

      # Mount all shares
      # @return [Array[Share]]
      def mount
        shares.all?(&:mount)
      end

      # Unmount all shares
      # @return [Array[Share]]
      def unmount
        shares.all?(&:unmount)
      end
    end
  end
end
