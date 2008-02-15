require 'digest/sha1'

module Apache

  class SecureDownload

    def initialize(secret)
      raise ArgumentError, 'secret string missing' unless @secret = secret
    end

    def check_access(request)
      return FORBIDDEN if request.param('timestamp').to_i < Time.now.to_i
      return FORBIDDEN if request.param('token') != compute_token(request)

      return OK
    end

    private

    def compute_token(request)
      Digest::SHA1.hexdigest(@secret + request.uri + request.param('timestamp'))
    end

  end

end
