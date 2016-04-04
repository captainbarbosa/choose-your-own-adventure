require 'active_record'

module Adventure
  class User < ActiveRecord::Base
    has_many :adventures
    has_many :steps, through: :adevntures
  end
end
