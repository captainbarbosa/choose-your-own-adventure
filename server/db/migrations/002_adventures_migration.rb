class AdventuresMigration < ActiveRecord::Migration
  def change
    create_table :adventures do |t|
      t.timestamps null: true
      t.integer :step_id
      t.string :adventure_name
    end
  end
end
