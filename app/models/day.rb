class Day < ApplicationRecord
  has_many :jobs, dependent: :destroy
  has_many :job_comments, dependent: :destroy

  validates :start, uniqueness: true
  validates :finish, uniqueness: true
end
