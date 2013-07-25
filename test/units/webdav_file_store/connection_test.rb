require_relative '../../test_helper'

module WebdavFileStore
  class ConnectionTest < MiniTest::Unit::TestCase
    def setup
      @path_to_demo = File.expand_path('../../../files/demo.txt', __FILE__)
      @file = File.open(@path_to_demo)
      @file_name = File.basename(@path_to_demo)
      @webdav_url = 'http://localhost/webdav/'
      @connection = Connection.new(@webdav_url, user: 'foo', password: 'bar')
    end

    def teardown
      @connection.delete(@file_name)
      @file.close
    end

    def test_setup
      assert_match /Demo File/, @file.read
    end

    def test_put
      @connection.put(@file_name, file: @file)
      expected = (200..204)
      assert(expected.include?(@connection.response.code.to_i), "response code #{@connection.response.code} should be in #{expected}")
    end

    def test_get
      test_put
      @file = File.open(@path_to_demo)
      @connection.get(@file_name)
      assert_equal(@file.read, @connection.response.body)
    end

    def test_delete
      test_put
      @connection.delete(@file_name)
      @connection.get(@file_name)
      assert_equal('404', @connection.response.code)
    end

    def test_response_code
      test_get
      assert_equal('200', @connection.response.code)
    end

  end
end
