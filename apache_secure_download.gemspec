# -*- encoding: utf-8 -*-
# stub: apache_secure_download 0.2.2 ruby lib

Gem::Specification.new do |s|
  s.name = "apache_secure_download"
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = "2013-12-19"
  s.description = "Apache module providing secure downloading functionality, just like Mongrel Secure Download does for mongrel."
  s.email = "jens.wille@gmail.com"
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["lib/apache/mock_constants.rb", "lib/apache/secure_download.rb", "lib/apache/secure_download/util.rb", "lib/apache/secure_download/version.rb", "COPYING", "ChangeLog", "README", "Rakefile", "spec/apache/secure_download/util_spec.rb", "spec/apache/secure_download_spec.rb", "spec/spec_helper.rb"]
  s.homepage = "http://github.com/blackwinter/apache_secure_download"
  s.licenses = ["AGPL-3.0"]
  s.post_install_message = "\napache_secure_download-0.2.2 [2013-12-19]:\n\n* Housekeeping.\n\n"
  s.rdoc_options = ["--title", "apache_secure_download Application documentation (v0.2.2)", "--charset", "UTF-8", "--line-numbers", "--all", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.11"
  s.summary = "Apache module providing secure downloading functionality, just like Mongrel Secure Download does for mongrel."
end
