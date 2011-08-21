class CreateCalls < ActiveRecord::Migration
  def self.up
    create_table :calls do |t|
      t.string :number
      t.integer :vote

      t.timestamps
    end
  end

  def self.down
    drop_table :calls
  end
end
