# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rr2fetcher}
  s.version = "0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jorge Cuadrado", "David Cuadrado"]
  s.date = %q{2009-06-08}
  s.default_executable = %q{rr2fetcher}
  s.description = %q{Download files from a rapidshare free account}
  s.email = ["krawek@gmail.com"]
  s.executables = ["rr2fetcher"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "bin/rr2fetcher", "lib/progressbar.rb", "lib/rr2fetcher.rb", "lib/rrs_parser.rb", "rr2fetcher.gemspec", "script/console", "script/destroy", "script/generate"]
  s.homepage = %q{http://github.com/dcu/rr2fetcher}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{rr2fetcher}
  s.rubygems_version = %q{1.3.4}
  s.summary = %q{Download files from a rapidshare free account}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<newgem>, [">= 1.4.1"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<newgem>, [">= 1.4.1"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.4.1"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
