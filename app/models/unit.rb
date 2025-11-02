class Unit < ApplicationRecord
  belongs_to :course

  has_many :lessons

  has_one_attached :cover do |attachable|
    attachable.variant :thumb, resize_to_limit: [ 640, 360 ]
  end

  def next
    next_unit = course.units.where("units.id > ?", id).order(:id).first
    next_unit.lessons.any? ? next_unit : nil
  end
end
