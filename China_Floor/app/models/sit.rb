class Sit < ActiveRecord::Base
  validates_presence_of :x, :y
  validates_numericality_of :x, :y, :only_integer => true
end
