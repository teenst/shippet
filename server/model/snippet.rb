# -*- coding: utf-8 -*-
module Model
  class Snippet < Collection
    def self.collection
      Model::Database.collection('snippet')
    end

    def self.create(data)
      #バリデーションをする
      id = self.insert({ mode: data["mode"] }.merge self.parse(data[:code]))
      self.find_by_id(id)
    end

    def self.parse(code)
      code.gsub!(/\r\n/,"\n")
      separator = /^#[ \t]*--[ \t]*\n/m
      return {body: code} unless  code =~ separator
      header, body = code.split(separator)
      snippet = ["name","key","condition","group","expand-env",
       "binding"].inject({ }){|ret,var|
        if /^#[ \t]*#{var}[ \t]*:[ \t](.+)\n/ =~ header 
          ret[var.to_sym] = $1.rstrip
        end
        ret
      }.merge({code: body})
      
      snippet
    end
  end
end
