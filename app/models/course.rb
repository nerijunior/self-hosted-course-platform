class Course < ApplicationRecord
  has_many :units

  enum :status, {
    importing: "importing",
    refreshing: "refreshing",
    imported: "imported",
    failed: "failed"
  }

  def thumb
    return unless units.first
    return unless units.first&.lessons.first
    units.first&.lessons.first&.cover
  end
end
