class UserLesson < ApplicationRecord
  belongs_to :user
  belongs_to :lesson

  scope :watched, -> { where(watched: true) }
  scope :unwatched, -> { where(watched: false) }

  def mark_as_watched!
    update(watched: true, watched_at: Time.current)
  end
end
