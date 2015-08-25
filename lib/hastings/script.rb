module Hastings
  class Script
    # These integrations in the meta require you to declare your network
    # shares up-front so they can be mounted by a separate script.
    #
    #=Example use:
    #   Hastings::Script.new do
    #     name "Script name"
    #     run_every 5.days
    #     share "//my_share/dir"
    #     share "//my_share/other_dir", username: "myuser", password: "12345"
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
    class Meta
      # @return [Array] array of declared shares
      def network_shares
        @shares = Hastings::FS::Net::Registry.new
      end

      # Registers share
      # @param share_url [String]
      # @return [Share]
      def network_share=(share_url, **args)
        network_shares << Hastings::FS::Net.new(share_url, **args)
      end
    end
  end
end
