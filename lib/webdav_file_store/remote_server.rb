
module WebdavFileStore
  module RemoteServer

    def self.settings(args)
      [:url, :user, :password].each do |method|
        value = args[method] || args[method.to_s]
        send("#{method}=", value) if value.present?
      end
      
    end

    def self.url
      @url
    end

    def self.url=(url)
      @url = url
    end

    def self.user
      @user
    end

    def self.user=(user)
      @user = user
    end

    def self.password
      @password
    end

    def self.password=(password)
      @password = password
    end

  end
end
