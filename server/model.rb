require 'model/database'
require 'model/collection'
require 'model/snippet'
require 'model/user'
require 'logger'

module Model
  def self.logger
    @logger ||= Logger.new($stderr)
  end
end
