class Lesson < ApplicationRecord
  belongs_to :unit

  has_many :user_lessons, dependent: :destroy
  has_many :watched_lessons, -> { where(user_lessons: { watched: true }) },
            through: :user_lessons, source: :lesson

  has_one_attached :cover do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 640, 360 ]
  end
end
