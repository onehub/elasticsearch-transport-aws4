# frozen_string_literal: true

lib = File.expand_path('../lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'elasticsearch-transport-aws4'
  spec.version       = '7.4.0'
  spec.authors       = ['Filip Tepper']
  spec.email         = ['filip@tepper.pl']

  spec.summary       = 'Signature Version 4 Elasticsearch Transport for AWS Elasticsearch Service'
  spec.homepage      = 'https://github.com/castle/elasticsearch-transport-aws4'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.require_paths = ['lib']

  spec.add_dependency 'aws-sigv4',                 '~> 1.0'
  spec.add_dependency 'elasticsearch-transport',   '~> 7.4.0'

  spec.add_development_dependency 'bundler',       '~> 1.10'
  spec.add_development_dependency 'elasticsearch', '~> 7.4.0'
  spec.add_development_dependency 'minitest',      '~> 5.8.2'
  spec.add_development_dependency 'rake',          '~> 10.0'
  spec.add_development_dependency 'timecop',       '~> 0.8.0'
  spec.add_development_dependency 'webmock',       '~> 1.22.1'
end
