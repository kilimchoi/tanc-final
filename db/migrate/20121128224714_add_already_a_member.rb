class AddAlreadyAMember < ActiveRecord::Migration
  def change
    add_column :members, :already_a_member, :string
  end
end
