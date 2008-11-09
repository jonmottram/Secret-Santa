class CreateWants < ActiveRecord::Migration
  def self.up
    create_table :wants do |t|
      t.column :user_id, :int
      t.column :wants, :string
      t.column :position, :int
    end
  end

  def self.down
    drop_table :wants
  end
end
