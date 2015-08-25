require "hastings/fs/net/share"

module Hastings
  module FS
    module Net
      # Cifs shares
      class Cifs < Share
        self.prefix = :cifs
        self.type   = :cifs
      end
    end
  end
end
