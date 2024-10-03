class JobComment < ApplicationRecord
  belongs_to :user
  belongs_to :day
  belongs_to :job
end
