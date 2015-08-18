require "hastings/mount/share"

module Hastings
  module Mount
    # Samba shares
    class Samba < Share
      self.prefix = :smb
      self.type   = :cifs
    end
  end
end
