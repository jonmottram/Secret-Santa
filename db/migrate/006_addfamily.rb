class Addfamily < ActiveRecord::Migration
  def self.up
    add_column :users, :family, :string
  end

  def self.down
    remove_column :users, :family
  end
end
