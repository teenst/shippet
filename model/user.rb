# -*- coding: utf-8 -*-
module Model
  class User < Collection

    def self.collection
      Model::Database.collection('user')
    end

    def self.find_by_auth_or_create(auth)
      self.find_by_auth(auth) || self.create(auth)
    end

    def self.find_by_auth(auth)
      user = self.collection.find_one({(auth["provider"] + "_id") => auth["uid"]})
      return unless user
      self.update_auth(self.new(user), auth)
    end

    def self.create(auth)
      provider = auth["provider"]
      user = Hash.new
      user[provider + "_id"] = auth["uid"]
      user["name"] = auth["user_info"]["nickname"]
      self.update_auth(self.find_by_id(self.insert(user)), auth)
    end

    def self.find_by_id(id)
      user = super
      return unless user
      self.new user
    end

    def self.update_auth(user, auth)
      provider = auth["provider"]
      user[provider + "_token"] = auth["credentials"]["token"]
      user[:twitter_secret] = auth["credentials"]["secret"] if provider == "twitter"
      self.collection.update({_id: user["_id"]}, user)
      user
    end

    def initialize(data)
      self.merge! data
    end
  end
end
