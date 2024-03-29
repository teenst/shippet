require 'mongo'
require 'bson'

module Model
  module Database
    def self.db
      @db ||= ::Mongo::Connection.new.db('shippet')
    end

    def self.collection(name)
      self.db.collection(name)
    end
  end
end

