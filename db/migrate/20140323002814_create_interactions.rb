class CreateInteractions < ActiveRecord::Migration
  def change
    create_table :interactions do |t|
      t.belongs_to :admin
      t.belongs_to :employee

      t.timestamps
    end
  end
end
