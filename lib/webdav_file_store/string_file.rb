# To change this template, choose Tools | Templates
# and open the template in the editor.

module WebdavFileStore
  class StringFile < String
    attr_reader :connection, :path
    def initialize(string, connection, path)
      @path = path
      @connection = connection
      super(string)
    end

    def stored_content
      remote.body if remote
    end

    private
    def remote
      connection.get(path)
    end
  end
end
