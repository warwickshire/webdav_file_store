require 'net/http'
module WebdavFileStore
  class Connection
    attr_accessor :url, :path, :response

    def initialize(url)
      @url = url
    end

    def get(file_name)
      self.path = [url, file_name].join
      generate_response_from_get
      response.body
    end

    def put(file)
      self.path = [url, File.basename(file.path)].join

      generate_response_from_put do |request|
        request.body_stream=file
        request["Content-Type"] = "multipart/form-data"
        request.add_field('Content-Length', file.size)
      end
      
      path
    end

    def uri
      URI.parse(path)
    end

    def http
      Net::HTTP.new(uri.host, uri.port)
    end

    def generate_response_from_get &request_mod
      generate_response_from(Net::HTTP::Get, &request_mod)
    end

    def generate_response_from_put &request_mod
      generate_response_from(Net::HTTP::Put, &request_mod)
    end

    def generate_response_from(net_http_class)
      request = net_http_class.new(uri.request_uri)
      request.basic_auth("foo", "bar")
      yield(request) if block_given?
      self.response = http.request(request)
    end

  end
end
