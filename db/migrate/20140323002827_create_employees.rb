class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name,  :null => false, :default => ""
      t.string :email, :null => false, :default => ""
      t.belongs_to :company

      t.timestamps
    end
  end
end
