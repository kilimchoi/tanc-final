class CreateDatabaseAdmins < ActiveRecord::Migration
  def change
    create_table :database_admins do |t|

      t.timestamps
    end
  end
end
