require "hastings/fs/net/registry"

module Hastings
  class Dsl
    # These integrations in the meta require you to declare your network
    # shares up-front so they can be mounted by a separate script.
    #
    # == Example use:
    #   Hastings.script do
    #     name "Script name"
    #     run_every 5.days
    #     network_share "//my_share/dir"
    #     network_share "//my_share/other_dir",
    #       username: "myuser", password: "12345"
    #
    #     run do
    #       var.dir = dir "//my_share/dir/something/here"
    #       var.other_dir = dir "//my_share/other_dir/something/here"
    #
    #       loop(var.dir.files) do |file|
    #         file.copy var.other_dir
    #       end
    #     end
    #   end
    #
    # Via the command line this would be accessible like this:
    #   hastings list network_share_commands
    module FS
      module Net
        module Meta
          # @return [Registry] Network Share Registry
          def network_shares
            @network_shares ||= Hastings::FS::Net::Registry.new
          end

          # see {Hastings::FS::Net::Registry#paths}
          # @return [Array[String]] array of share paths
          def network_share_paths
            network_shares.paths
          end

          # see {Hastings::FS::Net::Registry#commands}
          # @return [Array[String]] array of share commands
          def network_share_commands
            network_shares.commands
          end

          # Register share with this command
          # see {Hastings::FS::Net::Registry#add}
          # @param share_url [String]
          # @param args [Hash] Takes `username` and `password`
          # @return [Share]
          def network_share=(share_url, **args)
            network_shares.add share_url, **args
          end
        end
      end
    end

    class Meta
      include Hastings::Dsl::FS::Net::Meta
    end
  end
end
