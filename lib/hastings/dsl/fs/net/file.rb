require "hastings/fs/net/proxy_file"

module Hastings
  class Dsl
    module FS
      module Net
        # {Hastings::Dsl::FS::Net::File} is the module that contains our
        # #dir method. It delegates network drives to this gem.
        module File
          # Dsl method for file, delegates network drive files
          #
          # @param [String] path Path to file
          # @return [Hastings::FS::Net::ProxyFile|Hastings::File] File
          def file(path = nil)
            share = meta.network_shares.find_by_path(path)
            Hastings::FS::Net::ProxyFile.new share
          rescue Hastings::FS::Net::NotImplementedError
            super
          end
        end
      end
    end

    include FS::Net::File
  end
end
