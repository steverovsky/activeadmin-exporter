# -*- encoding: utf-8 -*-
require File.expand_path('../lib/active_admin/exporter/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'activeadmin-exporter'
  gem.version       = ActiveAdmin::Exporter::VERSION
  gem.authors       = ['Nikita Anistratenko']
  gem.email         = ['steverovsky@gmail.com']
  gem.description   = %q(ActiveAdmin plugin for expanding export possibilities.)
  gem.summary       = %q{Allows to asynchronously pack export result in ZIP and send it to email.}
  gem.homepage      = 'https://github.com/steverovsky/activeadmin-exporter'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_runtime_dependency 'activeadmin'
  gem.add_runtime_dependency 'sidekiq'
  gem.add_runtime_dependency 'rubyzip'
end
