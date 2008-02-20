#--
###############################################################################
#                                                                             #
# A component of apache_secure_download.                                      #
#                                                                             #
# Copyright (C) 2008 University of Cologne,                                   #
#                    Albertus-Magnus-Platz,                                   #
#                    50932 Cologne, Germany                                   #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@uni-koeln.de>                                    #
#                                                                             #
# apache_secure_download is free software: you can redistribute it and/or     #
# modify it under the terms of the GNU General Public License as published by #
# the Free Software Foundation, either version 3 of the License, or (at your  #
# option) any later version.                                                  #
#                                                                             #
# apache_secure_download is distributed in the hope that it will be useful,   #
# but WITHOUT ANY WARRANTY; without even the implied warranty of              #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General    #
# Public License for more details.                                            #
#                                                                             #
# You should have received a copy of the GNU General Public License along     #
# with apache_secure_download. If not, see <http://www.gnu.org/licenses/>.    #
#                                                                             #
###############################################################################
#++

require 'digest/sha1'
require 'uri'

module Apache

  class SecureDownload

    module Util

      extend self

      def token(secret, path, timestamp)
        Digest::SHA1.hexdigest(secret + path + timestamp.to_s)
      end

      def secure_url(secret, url, timestamp = Time.now + 60)
        path, _, query = URI.split(url)[5..7]
        path << '?' << query if query

        timestamp = timestamp.to_i

        url + "#{query ? '&' : '?'}timestamp=#{timestamp}&token=#{token(secret, path, timestamp)}"
      end

    end

  end

end
