module Hastings
  module Mount
    # A place to keep all of our shar
    class Registry
      attr_reader :shares

      def initialize
        @shares = []
      end

      def add(share)
        return added?(share) if added?(share)
        share.mounted? || share.mount!
        shares << share
      end

      # If we've already added
      def added?(share)
        shares.find { |s| s == share }
      end

      def remove(share)
        share.unmount!
        shares.delete(share)
      end

      def mount
        shares.all?(&:mount)
      end

      def unmount
        shares.all?(&:unmount)
      end
    end
  end
end
