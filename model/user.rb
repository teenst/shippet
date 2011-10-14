# -*- coding: utf-8 -*-
module Model
  class User < Collection

    def self.collection
      Model::Database.collection('user')
    end

    def self.find_or_create(data)
      provider = datap["provider"]
      user = self.collection.find_one({(provider + "_id") => data["uid"]})
      return self.create(data) unless user
      # トークン等のアップデート
      user
    end

    def self.create(data)
      provider = data["provider"]
      user = Hash.new
      user[provider + "_id"] = data["uid"]
      user["name"] = data["user_info"]["nickname"]
      user[provider + "_name"] = user["name"]
      user[provider + "_token"] = data["credentials"]["token"]

      if provider == "twitter"
        user[:twitter_secret] = data["credentials"]["secret"]
      end

      self.find_by_id self.insert user
    end
  end
end
