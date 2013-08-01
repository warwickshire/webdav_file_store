require_relative '../../test_helper'

module WebdavFileStore
  class StringFileTest < MiniTest::Unit::TestCase
    def setup
      @path_to_demo = File.expand_path('../../../files/demo.txt', __FILE__)
      @file = File.open(@path_to_demo)
      @path = 'some/place/file.txt'
    end

    def teardown
      @file.close
      connection.rmdir(@path.split('/').first)
    end

    def test_file
      connection.put(@path, file: @file)
      text = 'Something'
      string = StringFile.new(text, connection, @path)
      assert(string.kind_of?(String), "string should be kind of string")
      assert_equal(text.to_s, string.to_s)
      assert_equal(File.open(@path_to_demo).read, string.stored_content)
    end
  end
end
