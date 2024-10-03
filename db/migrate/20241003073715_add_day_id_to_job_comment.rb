class AddDayIdToJobComment < ActiveRecord::Migration[6.1]
  def change
    add_column :job_comments, :day_id, :integer
  end
end
