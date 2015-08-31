require "hastings/core"
require "hastings/fs"

require "hastings/fs/net/errors"
require "hastings/dsl/fs/net"

module Hastings
  module FS
    # {Hastings::FS::Net} contains methods pertaining to network shares
    #
    # Network files and drives are proxied to their mounted counterparts. It is
    # required to declare network shares ahead of time. This is an extension of
    # {Hastings::FS}.
    #
    # Implemented share types are:
    # * Samba
    # * Cifs
    #
    # == Example usage:
    #   Hastings.script do
    #     name "Networking script"
    #     description "My project's description"
    #     run_at "5AM"
    #
    #     network_drive "//mynetworkshare/foo/bar",
    #       username: "foo", password: "bar"
    #     network-drive "//othershare/bazinga"
    #   end
    module Net; end
  end
end
