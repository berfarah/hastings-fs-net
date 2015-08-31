Dir[File.expand_path("../types/*", __FILE__)].each(&method(:require))

module Hastings
  module FS
    module Net
      # {Registry} keeps track of all of our shares for us.
      #
      # == Why?
      # We require all
      # network drives to be registered in the script before runtime because
      # that allows our environment to mount them in advance.
      #
      # Our registry is accessible via the DSL metadata as network_shares.
      # See {Hastings::Dsl::FS::Net::Meta}
      class Registry
        attr_reader :shares

        def initialize
          @shares = []
        end

        # Instantiates a new share and registers it if it doesn't exist
        #
        # @param [String] path Share path
        # @param [Hash] **settings Valid options:
        #   * username
        #   * password
        # @return [Share] Share Object
        def add(path, **settings)
          share = new_share(path, **settings)
          return find(share) if find(share)
          shares << share
        end

        # Check to see if a share exists in the registry
        # @param share [Share]
        # @return [Share]
        def find(share)
          shares.find { |s| s == share }
        end

        # Find shares based on the base path
        #
        # @param [String] path Path to share
        # @return [Share] Share
        def find_by_path(path)
          find new_share(path) || fail(NotRegisteredError)
        end

        # Removes a share / equals share from the registry
        # @param path [String] Share path
        # @return [Share] Share Object
        def remove(path)
          shares.delete find new_share(path)
        end

        # Gets the share paths
        #
        # @return [Array[String]] Array of paths
        def paths
          shares.map(&:path)
        end

        # Gets the mount commands to run
        #
        # @return [Array[String]] Array of commands
        def commands
          shares.map(&:command)
        end

        # Checks whether it's a share and returns the type of
        # share it is
        #
        # @param [String] path Share path
        # @return [Share] Share object
        # @raise [NotImplementedError] If it isn't a valid share
        def share?(path)
          Share.descendants.find { |s| s.valid?(path) && s } ||
            fail(NotImplementedError)
        end

        private

          def new_share(path, **settings)
            share?(path).new(path, **settings)
          end
      end # Registry
    end # Net
  end # FS
end # Hastings
