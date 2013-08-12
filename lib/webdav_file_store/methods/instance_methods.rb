
module WebdavFileStore
  module Methods
    module InstanceMethods
      def store_webdav_file_locally
        populate_webdav_file_stores
        replace_webdav_file_store_attributes_with_file_names
      end

      def save_file_to_webdav
        webdav_file_stores.keys.each do |attribute|
          store = webdav_file_stores[attribute]
          next unless store
          store[:connection] = webdav_connection
          store[:connection].put(store[:path], file: store[:file])
        end
      end

      def webdav_connection
        WebdavFileStore::Connection.new(
          RemoteServer.url,
          user: RemoteServer.user,
          password: RemoteServer.password
        )
      end

      def webdav_file_stores
        @webdav_file_stores ||= create_empty_webdav_file_stores
      end

      def create_empty_webdav_file_stores
        self.class.webdav_file_store_attributes.inject(Hash.new) do |hash, attribute|
          hash[attribute] = nil
          hash
        end
      end

      def populate_webdav_file_stores
        webdav_file_stores.keys.each do |attribute|
            next unless self.respond_to?(attribute)
            stored_attribute = send(attribute)
            next unless stored_attribute.kind_of? File
            store = webdav_file_stores[attribute] ||= {}
            store[:file] = stored_attribute
            store[:path] = path_to_webdav_stored_file(attribute, File.basename(stored_attribute))
        end
      end

      def replace_webdav_file_store_attributes_with_file_names
        webdav_file_stores.each do |attribute, data|
          send("#{attribute}=".to_sym, File.basename(data[:file])) if data and data[:file]
        end
      end

      def path_to_webdav_stored_file(attribute, file_name)
        [
          self.class.to_s.tableize,
          self.id,
          attribute,
          file_name
        ].join('/')
      end
    end
  end
end
