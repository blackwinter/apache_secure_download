require File.expand_path(%q{../lib/apache/secure_download/version}, __FILE__)

begin
  require 'hen'

  Hen.lay! {{
    :gem => {
      :name         => %q{apache_secure_download},
      :version      => Apache::SecureDownload::VERSION,
      :summary      => %q{Apache module providing secure downloading functionality, just like Mongrel Secure Download does for mongrel.},
      :author       => %q{Jens Wille},
      :email        => %q{jens.wille@gmail.com},
      :homepage     => :blackwinter,
      :dependencies => %w[]
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end

desc "Run benchmarks"
task :bench do
  Dir["#{File.dirname(__FILE__)}/bench/**/*_bench.rb"].each { |bench|
    load bench, true
  }
end
