class Unit < ApplicationRecord
  belongs_to :course

  has_many :lessons, dependent: :destroy

  has_one_attached :cover do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 640, 360 ]
  end

  def completed_lessons_count
    lessons.joins(:user_lessons)
      .where(user_lessons: { user_id: Current.user })
      .count
  end

  def next
    next_unit = course.units.where("units.id > ?", id).order(:id).first
    return nil unless next_unit
    next_unit.lessons.any? ? next_unit : nil
  end
end
