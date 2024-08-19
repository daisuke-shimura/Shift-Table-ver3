class ChangeDatatypeTimeOfJobs < ActiveRecord::Migration[6.1]
  def change
    change_column :jobs, :time, :string
  end
end
