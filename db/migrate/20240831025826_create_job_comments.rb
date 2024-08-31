class CreateJobComments < ActiveRecord::Migration[6.1]
  def change
    create_table :job_comments do |t|
      t.text :comment
      t.integer :user_id
      t.integer :job_id

      t.timestamps
    end
  end
end
