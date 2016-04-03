class StepMigration < ActiveRecord::Migration

  def up
    drop_table :steps if table_exists?(:steps)
    create_table :steps do |t|
      t.timestamps null: true
      t.string :name
      t.boolean :start
      t.boolean :end
      t.text :optionA
      t.text :optionB
      t.text :text
      t.integer :adventure_id
    end
  end

  def down
    drop_table :steps if table_exists?(:steps)
  end
end
