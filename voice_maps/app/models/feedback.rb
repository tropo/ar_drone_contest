class Feedback < ActiveRecord::Base
  validates_presence_of :presentation_id

  belongs_to :presentation
end
