class Renamecolumn < ActiveRecord::Migration
  def self.up
    rename_column :wants, :wants, :gottahave
  end

  def self.down
    rename_column :wants, :gottahave, :wants
  end
end
