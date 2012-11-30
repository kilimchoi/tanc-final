class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
       t.string :id
       t.string :email
       t.string :name
       t.string :password
       t.string :status
       t.string :type
       t.boolean :confirmed

      t.timestamps
    end
  end
end
