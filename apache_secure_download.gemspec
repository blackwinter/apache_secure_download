# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{apache_secure_download}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = %q{2010-06-24}
  s.description = %q{Apache module providing secure downloading functionality, just like Mongrel Secure Download does for mongrel.}
  s.email = %q{jens.wille@uni-koeln.de}
  s.extra_rdoc_files = ["COPYING", "ChangeLog", "README"]
  s.files = ["lib/apache/secure_download/util.rb", "lib/apache/secure_download/version.rb", "lib/apache/secure_download.rb", "lib/apache/mock_constants.rb", "README", "ChangeLog", "Rakefile", "COPYING"]
  s.homepage = %q{http://prometheus.rubyforge.org/apache_secure_download}
  s.rdoc_options = ["--charset", "UTF-8", "--title", "apache_secure_download Application documentation", "--main", "README", "--line-numbers", "--inline-source", "--all"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{prometheus}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Apache module providing secure downloading functionality, just like Mongrel Secure Download does for mongrel.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
