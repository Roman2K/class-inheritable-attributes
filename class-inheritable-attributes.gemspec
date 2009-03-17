# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{class-inheritable-attributes}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Roman Le N\303\251grate"]
  s.date = %q{2009-03-17}
  s.description = %q{Thread-safe class inheritable attributes}
  s.email = %q{roman.lenegrate@gmail.com}
  s.extra_rdoc_files = ["lib/class_inheritable_attributes.rb", "LICENSE", "README.mdown"]
  s.files = ["lib/class_inheritable_attributes.rb", "LICENSE", "Manifest", "Rakefile", "README.mdown", "test/class_inheritable_attributes_test.rb", "class-inheritable-attributes.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{https://github.com/Roman2K/class-inheritable-attributes}
  s.rdoc_options = ["--main", "README.mdown", "--inline-source", "--line-numbers", "--charset", "UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{class-inheritable-attributes}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Thread-safe class inheritable attributes}
  s.test_files = ["test/class_inheritable_attributes_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
