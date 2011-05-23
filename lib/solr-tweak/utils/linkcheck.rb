class Linkcheck
	require 'net/http'
	require 'uri'
	require 'open-uri'

	def self.basic(url) #checks for 200
		url << '/' unless url[-1] == '/' #add slash
		return true unless url[0..3] == 'http' #check is a url

 	
		url = URI.parse(url)
  	begin
    	req = Net::HTTP::Get.new(url.path)
  	rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, Errno::ENETUNREACH, Errno::ETIMEDOUT, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError, SocketError => e
    	return true
  	end
  	begin  
    	res = Net::HTTP.start(url.host, url.port) do |http|
      	http.request(req)
        if http.head(url.request_uri).code == "200"
        	return nil
        else
          return true
        end
    	end
  	rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, Errno::ENETUNREACH, Errno::ETIMEDOUT, Errno::ECONNREFUSED, EOFError, Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError, SocketError => e
    	return true
  	end
	end

end
