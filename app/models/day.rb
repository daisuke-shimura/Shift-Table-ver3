class Day < ApplicationRecord
  has_many :jobs, dependent: :destroy
  has_many :job_comments, dependent: :destroy
  has_many :mons, dependent: :destroy
  has_many :tues, dependent: :destroy
  has_many :weds, dependent: :destroy
  has_many :thus, dependent: :destroy
  has_many :fris, dependent: :destroy
  has_many :sats, dependent: :destroy

  validates :start, uniqueness: true
  validates :finish, uniqueness: true

  def mon_by?(n)
    mons.exists?(day_id: n)
  end

  def tue_by?(n)
    tues.exists?(day_id: n)
  end

  def wed_by?(n)
    weds.exists?(day_id: n)
  end

  def thu_by?(n)
    thus.exists?(day_id: n)
  end

  def fri_by?(n)
    fris.exists?(day_id: n)
  end

  def sat_by?(n)
    sats.exists?(day_id: n)
  end

end
