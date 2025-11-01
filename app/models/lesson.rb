class Lesson < ApplicationRecord
  belongs_to :course
  belongs_to :unit
end
