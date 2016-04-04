class UsersMigration < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps null: true
      t.string :token
    end
  end
end
