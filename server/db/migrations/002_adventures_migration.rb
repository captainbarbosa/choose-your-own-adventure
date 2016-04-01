class AdventuresMigration < ActiveRecord::Migration
  def change
    create_table :adventures do |t|
      t.timestamps null: true
      t.string :adventure_name
      t.integer :user_id
    end
  end
end
