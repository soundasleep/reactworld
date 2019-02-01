class Game < ApplicationRecord
  belongs_to :user

  has_many :levels, dependent: :destroy
  belongs_to :current_level, class_name: "Level", foreign_key: :current_level_id, optional: true

  validates :player_x, :player_y,
    numericality: { greater_than_or_equal: 0 }, allow_nil: true

  def to_s
    "<Game #{id} at depth #{current_level&.depth || "(none)"}>"
  end

  def finished?
    finished_at.present?
  end
end
