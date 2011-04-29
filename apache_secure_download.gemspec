# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{apache_secure_download}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = %q{2011-04-29}
  s.description = %q{Apache module providing secure downloading functionality, just like Mongrel Secure Download does for mongrel.}
  s.email = %q{jens.wille@uni-koeln.de}
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["lib/apache/secure_download/util.rb", "lib/apache/secure_download/version.rb", "lib/apache/secure_download.rb", "lib/apache/mock_constants.rb", "README", "ChangeLog", "Rakefile", "COPYING", "spec/spec.opts", "spec/apache/secure_download/util_spec.rb", "spec/apache/secure_download_spec.rb", "spec/spec_helper.rb"]
  s.homepage = %q{http://prometheus.rubyforge.org/apache_secure_download}
  s.rdoc_options = ["--charset", "UTF-8", "--title", "apache_secure_download Application documentation (v0.1.1)", "--main", "README", "--line-numbers", "--all"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{prometheus}
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Apache module providing secure downloading functionality, just like Mongrel Secure Download does for mongrel.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
