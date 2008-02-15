require 'digest/sha1'

module Apache

  class SecureDownload

    def initialize(secret)
      raise ArgumentError, 'secret string missing' unless secret

      @secret = secret
    end

    def check_access(request)
      path      = request.uri
      timestamp = request.param('timestamp')
      token     = request.param('token')

      return FORBIDDEN if timestamp.to_i < Time.now.to_i
      return FORBIDDEN if token != compute_token(path, timestamp)

      return OK
    end

    private

    def compute_token(path, timestamp)
      Digest::SHA1.hexdigest(@secret + path + timestamp)
    end

  end

end
