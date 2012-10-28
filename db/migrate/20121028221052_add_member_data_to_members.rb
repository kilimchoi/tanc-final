class AddMemberDataToMembers < ActiveRecord::Migration
  def change
    add_column :members, :first, :string
    add_column :members, :last, :string
    add_column :members, :age, :integer
    add_column :members, :address1, :string
    add_column :members, :address2, :string
    add_column :members, :city, :string
    add_column :members, :state, :string
    add_column :members, :zip, :string
    add_column :members, :telephone, :string
  end
end
