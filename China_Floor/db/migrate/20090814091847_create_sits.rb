class CreateSits < ActiveRecord::Migration
  def self.up
    create_table :sits do |t|
      t.integer :x
      t.integer :y
      t.string :user
      t.boolean :used

      t.timestamps
    end
  end

  def self.down
    drop_table :sits
  end
end
