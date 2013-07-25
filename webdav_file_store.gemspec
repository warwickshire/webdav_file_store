$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "webdav_file_store/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "webdav_file_store"
  s.version     = WebdavFileStore::VERSION
  s.authors     = ["Rob Nichols"]
  s.email       = ["rob@undervale.co.uk"]
  s.homepage    = "https://github.com/warwickshire/webdav_file_store"
  s.summary     = "Facilitates file storage on a remote WebDav server."
  s.description = s.summary
  s.license = 'MIT-LICENSE'
  s.files = Dir["{lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

#  s.add_dependency "anything?"


end
