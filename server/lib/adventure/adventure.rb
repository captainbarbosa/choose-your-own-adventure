require 'active_record'

module Adventure
  class Adventure < ActiveRecord::Base
    has_many :steps
    belongs_to :user
  end
end
