class Monster < ApplicationRecord
  belongs_to :level

  validates :monster_x, :monster_y, :health, :monster_level,
    presence: true, numericality: true

  validates :monster_type, presence: true

  SPIDER = "spider"

  def to_s
    "<Monster #{id}:#{monster_type} (#{health} hp)>"
  end

  def alive?
    health > 0
  end

  def dead?
    !alive?
  end
end
