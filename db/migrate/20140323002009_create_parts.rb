class CreateParts < ActiveRecord::Migration
  def change
    create_table :parts do |t|
      t.text       :content, :null => false, :default => ""
      t.belongs_to :gmail_message

      t.timestamps
    end
  end
end
