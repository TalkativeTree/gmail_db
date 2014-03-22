class AddGmailEmailToAdmin < ActiveRecord::Migration
  def self.up
    add_column :admins, :gmail_password, :string, :null => false, :default => ""
    add_column :admins, :password_hash, :string, :null => false, :default => ""
  end

  def self.down
    remove_column :admins, :gmail_password
    remove_column :admins, :password_hash
  end
end
