class Job < ApplicationRecord

  belongs_to :user
  has_many :job_comments, dependent: :destroy

  def comment_by?(ogawa)
    job_comments.exists?(user_id: ogawa)
  end
  
  def time_by?
    time1.empty?
  end

end
