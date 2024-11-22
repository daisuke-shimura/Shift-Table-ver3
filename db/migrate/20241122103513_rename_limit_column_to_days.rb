class RenameLimitColumnToDays < ActiveRecord::Migration[6.1]
  def change
    rename_column :days, :limit, :limityan
  end
end
