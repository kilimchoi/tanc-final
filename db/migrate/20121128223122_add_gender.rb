class AddGender < ActiveRecord::Migration
  def change
    add_column :members, :gender, :male
  end
end
