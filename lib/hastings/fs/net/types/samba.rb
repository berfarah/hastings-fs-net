require "hastings/fs/net/share"

module Hastings
  module FS
    module Net
      # Samba shares
      class Samba < Share
        self.prefix = :smb
        self.type   = :cifs
      end
    end
  end
end
