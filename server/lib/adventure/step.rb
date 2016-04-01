module Adventure
  class Step < ActiveRecord::Base
    belongs_to :adventure
  end
end
