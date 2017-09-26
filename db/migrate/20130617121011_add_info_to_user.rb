class AddInfoToUser < ActiveRecord::Migration
  def change
    add_column :users, :true_name, :string
    add_column :users, :sex, :string
    add_column :users, :birthday, :string
    add_column :users, :university, :string
    add_column :users, :school_year, :string
    add_column :users, :love_status, :string
    add_column :users, :location, :string
  end
end
