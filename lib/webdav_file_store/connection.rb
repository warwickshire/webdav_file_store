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
      generate_response_with(Net::HTTP::Get)
    end

    def delete(file_name)
      self.file_name = file_name
      generate_response_with(Net::HTTP::Delete)
    end

    def mkdir(folder)
      self.file_name = folder
      generate_response_with(Net::HTTP::Mkcol)
      '201' == response.code
    end

    def folder_exist?(folder)
      self.file_name = folder
      generate_response_with(Net::HTTP::Propfind)
      /(2|3)\d\d/ =~ response.code
    end

    def rmdir(folder)
      delete folder << '/'
    end

    def put(file_name, options = {})
      self.file_name = file_name
      file = data_for(options, :file)

      ensure_path_to_file_exists

      generate_response_with(Net::HTTP::Put) do |request|
        if file
          request.body_stream=file
          request["Content-Type"] = "multipart/form-data"
          request.add_field('Content-Length', file.size)
        end
      end      
    end

    def generate_response_with(net_http_class)
      request = net_http_class.new(uri.request_uri)
      request.basic_auth(user, password) if user
      yield(request) if block_given?
      self.response = http.request(request)
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

    def data_for(hash, attribute)
      hash[attribute.to_sym] || hash[attribute.to_s]
    end

    def ensure_path_to_file_exists
      slash_pattern = /\//
      different_connection = clone # Using another connection, so that actions done here don't overwrite main connection methods
      file_name.split(slash_pattern).inject do |current, element|
        different_connection.mkdir(current) unless different_connection.folder_exist? current
        [current, element].join('/')
      end if slash_pattern =~ file_name
    end

  end
end
