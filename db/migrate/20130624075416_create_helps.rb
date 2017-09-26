class CreateHelps < ActiveRecord::Migration
  def change
    create_table :helps do |t|
      t.string :content
      t.string :time
      t.string :reward
      t.string :user_id

      t.timestamps
    end	
    add_index :helps, :user_id
  end
end
