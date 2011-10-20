require 'hashie'

module Model
  class Collection < Hash
    include Hashie::Extensions::MethodAccess

    def self.collection
      raise NotImplementedError
    end

    def self.insert(data)
      self.collection.insert data
    end

    def self.find_by_id(id)
      self.collection.find_one _id: id
    end

    def self.remove(id)
      self.collection.remove _id: id
    end

    def id
      self._id
    end
  end
end
