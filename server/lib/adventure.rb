require 'active_record'
require_relative 'adventure/database'
require_relative 'adventure/step'

module Adventure
  class Adventure < ActiveRecord::Base
    has_many :steps
    belongs_to :user
  end
end
