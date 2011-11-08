# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "apache_secure_download"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jens Wille"]
  s.date = "2011-11-08"
  s.description = "Apache module providing secure downloading functionality, just like Mongrel Secure Download does for mongrel."
  s.email = "jens.wille@uni-koeln.de"
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["lib/apache/secure_download.rb", "lib/apache/mock_constants.rb", "lib/apache/secure_download/util.rb", "lib/apache/secure_download/version.rb", "ChangeLog", "COPYING", "README", "Rakefile", "spec/apache/secure_download_spec.rb", "spec/apache/secure_download/util_spec.rb", "spec/spec_helper.rb", ".rspec"]
  s.homepage = "http://prometheus.rubyforge.org/apache_secure_download"
  s.rdoc_options = ["--title", "apache_secure_download Application documentation (v0.2.0)", "--line-numbers", "--main", "README", "--all", "--charset", "UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "prometheus"
  s.rubygems_version = "1.8.11"
  s.summary = "Apache module providing secure downloading functionality, just like Mongrel Secure Download does for mongrel."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
