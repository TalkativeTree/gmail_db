class CreateGmailMessages < ActiveRecord::Migration
  def change
    create_table :gmail_messages do |t|
      t.string :uid, :null => false, :default => ""
      t.string :boundary
      t.datetime :date

      t.string :from, :null => false, :default => ""
      t.string :to, array: true, default: []
      t.string :cc, array: true, default: []
      t.string :bcc, array: true, default: []
      t.text :raw_source, :null => false, :default => ""

      t.belongs_to :admin
      t.timestamps
    end
  end
end
