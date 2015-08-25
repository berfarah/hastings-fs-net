require "hastings/core"
require_relative "net/registry"
require_relative "net/proxy_dir"
Dir[File.expand_path("../net/types/*", __FILE__)].each(&method(:require))

module Hastings
  module FS
    # Handles our mount operations and namespaces this gem
    module Net
      def self.new(path, **settings)
        share?(path).new(path, **settings)
      end

      def self.share?(path)
        Share.descendants.find { |s| s.valid?(path) && s } ||
          fail(NotImplementedError)
      end
    end
  end
end
