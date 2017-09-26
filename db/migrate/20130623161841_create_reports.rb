class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :title
      t.string :course
      t.string :content
      t.integer :user_id

      t.timestamps
    end
     add_index :reports, :user_id
  end
end
