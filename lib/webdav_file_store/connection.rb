require 'net/http'
module WebdavFileStore
  class Connection
    attr_accessor :url, :response, :file_name, :user, :password

    def initialize(url, options = {})
      self.url = url
      self.user = data_for(options, :user)
      self.password = data_for(options, :password)
    end

    def get(file_name)
      self.file_name = file_name
      generate_response_from(Net::HTTP::Get)
    end

    def put(file_name, options = {})
      self.file_name = file_name
      file = data_for(options, :file)

      generate_response_from(Net::HTTP::Put) do |request|
        if file
          request.body_stream=file
          request["Content-Type"] = "multipart/form-data"
          request.add_field('Content-Length', file.size)
        end
      end      
    end

    def delete(file_name)
      self.file_name = file_name
      generate_response_from(Net::HTTP::Delete)
    end

    def uri
      URI.parse(path)
    end

    def http
      Net::HTTP.new(uri.host, uri.port)
    end

    def path
      [url_without_trailing_slash, file_name].join('/')
    end

    def url_without_trailing_slash
      url.gsub(/\/$/, "")
    end

    def generate_response_from(net_http_class)
      request = net_http_class.new(uri.request_uri)
      request.basic_auth(user, password) if user
      yield(request) if block_given?
      self.response = http.request(request)
    end

    def data_for(hash, attribute)
      hash[attribute.to_sym] || hash[attribute.to_s]
    end

  end
end
