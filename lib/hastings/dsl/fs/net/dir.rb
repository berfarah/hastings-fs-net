require "hastings/fs/net/proxy_dir"

module Hastings
  class Dsl
    module FS
      module Net
        # bla bla bla
        module Dir
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
