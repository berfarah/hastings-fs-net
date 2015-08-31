require "hastings/fs/net/proxy_dir"

module Hastings
  class Dsl
    module FS
      module Net
        # {Hastings::Dsl::FS::Net::Dir} is the module that contains our
        # #dir method. It delegates network drives to this gem.
        module Dir
          # Dsl method for dir, delegates network drives
          #
          # @param [String] path Path to directory
          # @return [Hastings::FS::Net::ProxyDir|Hastings::Dir] Directory
          def dir(path = nil)
            share = meta.network_shares.find_by_path(path)
            Hastings::FS::Net::ProxyDir.new share
          rescue Hastings::FS::Net::NotImplementedError
            super
          end
        end
      end
    end

    include FS::Net::Dir
  end
end
