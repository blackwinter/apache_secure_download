require %q{lib/apache/secure_download/version}

begin
  require 'hen'

  Hen.lay! {{
    :rubyforge => {
      :project => %q{prometheus},
      :package => %q{apache_secure_download}
    },

    :gem => {
      :version      => Apache::SecureDownload::VERSION,
      :summary      => %q{Apache module providing secure downloading functionality, just like Mongrel Secure Download does for mongrel.},
      :files        => FileList['lib/**/*.rb'].to_a,
      :extra_files  => FileList['[A-Z]*'].to_a,
      :dependencies => %w[]
    }
  }}
rescue LoadError
  abort "Please install the 'hen' gem first."
end

### Place your custom Rake tasks here.
