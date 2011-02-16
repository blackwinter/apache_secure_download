require File.expand_path(%q{../lib/apache/secure_download/version}, __FILE__)

begin
  require 'hen'

  Hen.lay! {{
    :rubyforge => {
      :project => %q{prometheus},
      :package => %q{apache_secure_download}
    },

    :gem => {
      :version => Apache::SecureDownload::VERSION,
      :summary => %q{Apache module providing secure downloading functionality, just like Mongrel Secure Download does for mongrel.},
      :author  => %q{Jens Wille},
      :email   => %q{jens.wille@uni-koeln.de}
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end

