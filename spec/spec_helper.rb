$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "simplecov"
require "fileutils"

SimpleCov.start { add_filter "_spec" }
require "hastings/mount"

RSpec.configure do |config|
  config.before(:suite) do
    @tmpdir = "/tmp/ruby_tests/hastings"
    FileUtils.mkdir_p(@tmpdir)
    Dir.chdir(@tmpdir)
  end

  config.after(:suite) do
    FileUtils.rm_rf(@tmpdir)
  end
end
