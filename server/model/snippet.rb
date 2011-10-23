# -*- coding: utf-8 -*-
require 'json'

module Model
  class Snippet < Collection
    def self.collection
      Model::Database.collection('snippet')
    end

    def self.find_by_id(id)
      self.new super
    end

    def self.create(data)
      #バリデーションをする
      id = self.insert({ mode: data["mode"] }.merge self.parse(data[:code]))
      self.find_by_id(id)
    end

    def self.parse(code)
      code.gsub!(/\r\n/,"\n")
      separator = /^#[ \t]*--[ \t]*\n/m
      return {code: code} unless code =~ separator
      header, body = code.split(separator)
      self.header_keys.inject({code: body}){|ret,var|
        if /^#[ \t]*#{var}[ \t]*:[ \t](.+)\n/ =~ header
          ret[var.to_sym] = $1.rstrip
        end
        ret
      }
    end

    def self.header_keys
      ["name", "key", "condition", "group", "expand-env", "binding"]
    end

    def self.remove(id)
      # 作者のみ消せるにする
      super
    end

    def initialize(data)
      self.merge! data
    end

    def to_json
      index = 1
      header = Snippet.header_keys.inject(""){|ret, key|
        if self.has_key? key
          ret += "##{key}: ${#{index}:#{self[key]}}\n"
          index += 1
        end
        ret
      }
      JSON.unparse({
          mode: self["mode"],
          snippet: header + "#--\n" + self["code"]
        })
    end
  end
end
