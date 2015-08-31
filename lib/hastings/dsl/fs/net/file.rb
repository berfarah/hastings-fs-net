require "hastings/fs/net/proxy_file"

module Hastings
  class Dsl
    module FS
      module Net
        # bla bla bla
        module File
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
