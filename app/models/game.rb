class Game < ApplicationRecord
  belongs_to :user

  def to_s
    "<Game #{id}>"
  end

  def finished?
    finished_at.present?
  end
end
