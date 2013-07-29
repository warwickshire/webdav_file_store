require_relative '../../test_helper'

module WebdavFileStore
  class ConnectionTest < MiniTest::Unit::TestCase
    def setup
      @path_to_demo = File.expand_path('../../../files/demo.txt', __FILE__)
      @file = File.open(@path_to_demo)
      @file_name = File.basename(@path_to_demo)
      @path = 'somewhere/else'
    end

    def teardown
      connection.delete(@file_name)
      @file.close
      connection.rmdir(@path.split('/').first)
    end

    def test_setup
      assert_match /Demo File/, @file.read
    end

    def test_put
      connection.put(@file_name, file: @file)
      assert_responded_with_code successful_put_codes
    end

    def test_put_into_path
      path = [@path, @file_name].join('/')
      assert_connection connection.put(path, file: @file)
      assert_responded_with_code successful_put_codes
      assert_connection connection.get(path)
      assert_responded_with_code 200
    end

    def test_get
      test_put
      @file = File.open(@path_to_demo)
      connection.get(@file_name)
      assert_equal(@file.read, connection.response.body)
    end

    def test_delete
      test_put
      connection.delete(@file_name)
      assert_connection connection.get(@file_name)
      assert_responded_with_code 404
    end

    def test_response_code
      test_get
      assert_responded_with_code 200
    end

    def assert_connection(connection_call)
      assert connection_call, "Connection call should return true: #{connection.response.body}"
    end

    def assert_responded_with_code(codes)
      response_code = connection.response.code.to_i
      if codes.respond_to? :include?
        assert codes.include?(response_code), "#{response_code}, should be one of #{codes}"
      else
        assert_equal(codes, response_code)
      end
    end

    def successful_put_codes
      [201, 204, 301]
    end

  end
end
