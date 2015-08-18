require "hastings/mount/share"

module Hastings
  module Mount
    # Cifs shares
    class Cifs < Share
      self.prefix = :cifs
      self.type   = :cifs
    end
  end
end
