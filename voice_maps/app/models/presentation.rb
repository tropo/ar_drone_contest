class Presentation < ActiveRecord::Base
  validates_presence_of :name, :title

  has_many :feedbacks
end
