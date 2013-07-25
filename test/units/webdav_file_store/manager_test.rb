require_relative '../../test_helper'

module WebdavFileStore
  class ManagerTest < MiniTest::Unit::TestCase
    def setup
      path_to_demo = File.expand_path('../../../files/demo.txt', __FILE__)
      @file = File.open(path_to_demo)
    end

    def teardown
      @file.close
    end

    def test_file
      assert_match /Demo File/, @file.read
    end
  end
end
