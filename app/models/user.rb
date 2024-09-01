class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

 # has_many :jobs, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :job_comments, dependent: :destroy

  def job_by?(ogatyan)
    jobs.exists?(user_id: ogatyan)
  end

end
