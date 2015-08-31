# Hastings::Mount

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hastings-fs-net'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hastings-mount

## Usage

Because mounting shares often requires root permissions, shares need to be declared up-front so that
a separate script can then mount them. In the `Hastings` docker container, this is done for you
automatically.

Mounted directories act just like normal directories, but are proxied via the Hastings mount path.

```ruby
Hastings::Script.new do
  name "Script name"
  run_every 5.days
  network_share "//my_share/dir"
  network_share "//my_share/other_dir"

  run do
    var.dir = dir "//my_share/dir/something/here"
    var.other_dir = dir "//my_share/other_dir/something/here"
    loop(var.dir.files) do |file|
      file.copy var.other_dir
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/berfarah/hastings-mount.
