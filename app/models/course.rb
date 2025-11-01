class Course < ApplicationRecord
  has_many :units

  enum :status, {
    importing: "importing",
    refreshing: "refreshing",
    imported: "imported",
    failed: "failed"
  }
end
