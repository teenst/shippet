# -*- coding: utf-8 -*-
module Model
  class Snippet < Collection
    def self.collection
      Model::Database.collection('snippet')
    end

    def self.create(data)
      #バリデーションをする
      data.merge! self.parse(data[:code])
      id = self.insert(data)
      self.find_by_id(id)
    end

    def self.parse(code)
      separator = /^#[ \t]*--\s*\r\n/
      return {body: code} unless  code =~ separator
      header, body = code.split(separator)

      p header
      p body
      {body: body}
    end
  end
end
