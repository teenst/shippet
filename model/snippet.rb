# -*- coding: utf-8 -*-
module Model
  class Snippet
    def self.collection
      Model::Database.collection('snippet')
    end
    
    def self.create(data)
      #バリデーションをする
      id = self.collection.insert(data)

      self.collection.find_one(_id: id)
      
    end
    
  end
end
