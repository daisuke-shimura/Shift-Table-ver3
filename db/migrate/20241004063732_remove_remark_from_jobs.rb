class RemoveRemarkFromJobs < ActiveRecord::Migration[6.1]
  def change
    remove_column :jobs, :remark, :string
    remove_column :jobs, :day, :integer
  end
end
