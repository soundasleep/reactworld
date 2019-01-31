class User < ApplicationRecord
  has_many :games, dependent: :destroy

  def to_s
    "<User #{id}: #{name} (#{uid})>"
  end
end
