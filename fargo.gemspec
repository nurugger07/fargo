require File.expand_path('../lib/fargo/version',__FILE__)

Gem::Specification.new do |gem|
  gem.authors          = ["Johnny Winn"]
  gem.email            = ["j.winn.v@gmail.com"]
  gem.description      = "FTP client"
  gem.summary          = "Easy to use FTP client"
  gem.homepage         = "http://nurugger07.github.com/fargo"

  gem.add_development_dependency("rake")
  gem.add_development_dependency("rspec", "~>2.11")
end
