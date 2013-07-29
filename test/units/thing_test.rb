require_relative '../test_helper'
require 'thing'

class ThingTest < ActiveSupport::TestCase

  def setup
    @thing = Thing.find(1)
    @file = File.open(File.expand_path("../../files/demo.txt", __FILE__))
  end

  def teardown
    @file.close if @file
    connection.rmdir('things')
  end

  def test_setup
    assert_equal 'Foo', @thing.name
  end

  def test_file_sent_to_webdav_on_save
    assert_attachment_not_in_webdav
    @thing.attachment = @file
    @thing.save
    assert_match(/20\d/, @thing.connection.response.code)
    assert_attachment_in_webdav
  end

  def assert_attachment_not_in_webdav
    assert_equal('404', connection.get(@thing.attachment).response.code)
  end

  def assert_attachment_in_webdav
    assert_match(/20\d/, connection.get(@thing.attachment).response.code)
  end
end
