module Model
  class Collection
    def self.collection
      raise NotImplementedError
    end

    def self.insert(data)
      self.collection.insert data
    end

    def self.find_by_id(id)
      self.collection.find_one _id: id
    end
  end
end
