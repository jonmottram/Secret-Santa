class Addcreatedon < ActiveRecord::Migration
  def self.up
    add_column :wants, :created_on, :datetime
  end

  def self.down
    remove_column :wants, :created_on
  end
end
