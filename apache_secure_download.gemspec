# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "apache_secure_download"
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = "2013-07-15"
  s.description = "Apache module providing secure downloading functionality, just like Mongrel Secure Download does for mongrel."
  s.email = "jens.wille@gmail.com"
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["lib/apache/mock_constants.rb", "lib/apache/secure_download.rb", "lib/apache/secure_download/util.rb", "lib/apache/secure_download/version.rb", "COPYING", "ChangeLog", "README", "Rakefile", "spec/apache/secure_download/util_spec.rb", "spec/apache/secure_download_spec.rb", "spec/spec_helper.rb", ".rspec"]
  s.homepage = "http://github.com/blackwinter/apache_secure_download"
  s.licenses = ["AGPL"]
  s.rdoc_options = ["--charset", "UTF-8", "--line-numbers", "--all", "--title", "apache_secure_download Application documentation (v0.2.1)", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.5"
  s.summary = "Apache module providing secure downloading functionality, just like Mongrel Secure Download does for mongrel."
end
