class Job < ApplicationRecord

  belongs_to :user
  belongs_to :day
  has_many :job_comments, dependent: :destroy

  def comment_by?(n,m)
    job_comments.exists?(user_id: n, day_id: m)
  end
  
  def time_by?
    time1.empty?
  end

end
