require_relative '../../test_helper'

module WebdavFileStore
  class ConnectionTest < MiniTest::Unit::TestCase
    def setup
      @path_to_demo = File.expand_path('../../../files/demo.txt', __FILE__)
      @file = File.open(@path_to_demo)
      @webdav_url = 'http://localhost/webdav/'
      @connection = Connection.new(@webdav_url)
    end

    def teardown
      @file.close
    end

    def test_setup
      assert_match /Demo File/, @file.read
    end

    def test_put
      url = @connection.put(@file)
      assert_equal([@webdav_url, File.basename(@file.path)].join, url)
    end

    def test_get
      test_put
      @file = File.open(@path_to_demo)
      assert_equal(@file.read, @connection.get(File.basename(@file.path)))
    end

  end
end
