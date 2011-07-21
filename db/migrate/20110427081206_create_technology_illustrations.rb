class CreateTechnologyIllustrations < ActiveRecord::Migration
  def self.up
    create_table :technology_illustrations do |t|
      t.string :name
      t.text :description
      t.string :capital_size
      t.string :operating_size
      t.integer :technology_id

      t.timestamps
    end
  end

  def self.down
    drop_table :technology_illustrations
  end
end
