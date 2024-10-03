class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :jobs, dependent: :destroy
  has_many :job_comments, dependent: :destroy

  def job_by?(n,m)
    jobs.exists?(user_id: n, day_id: m)
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end

end
