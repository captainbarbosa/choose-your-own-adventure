require 'active_record'

class User < ActiveRecord::Base
  has_many :adventures
  has_many :steps, through: :adevntures


end
