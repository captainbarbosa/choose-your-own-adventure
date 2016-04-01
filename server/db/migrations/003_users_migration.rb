class UsersMigration < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps null: true
      t.string :token
      t.integer :adventure_id
    end
  end
end
