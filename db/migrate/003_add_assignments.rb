class AddAssignments < ActiveRecord::Migration
  def self.up
    add_column :users, :assigned, :string
  end

  def self.down
    remove_column :users, :assigned
  end
end
