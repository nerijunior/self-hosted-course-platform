class Lesson < ApplicationRecord
  belongs_to :unit

  has_one_attached :cover do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 640, 360 ]
  end
end
