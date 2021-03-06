# coding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "hastings-fs-net"
  spec.version       = "0.3.2"
  spec.authors       = ["Bernardo Farah"]
  spec.email         = ["ber@bernardo.me"]

  spec.summary       = "Mounted network drives for Hastings"
  spec.description   = "Integrates mounting network shares and proxies them as"\
                       " Hastings dirs"
  spec.homepage      = "http://github.com/berfarah/hastings-fs-net"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "yard", "~> 0.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
