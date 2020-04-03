
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "slack_mailer/version"

Gem::Specification.new do |spec|
  spec.name          = "slack_mailer"
  spec.version       = Slack::Mailer::VERSION
  spec.authors       = ["Appodeal"]
  spec.email         = ["p@appodeal.com"]

  spec.summary       = %q{This gem make more comfortable working with slack}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/appodeal/slack_mailer"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16.a"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "slack-notifier", "~> 2.3.2"
end
