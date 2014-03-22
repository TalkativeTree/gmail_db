class Admin < ActiveRecord::Base
  include BCrypt

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def gmail_password
    @gmail_password ||= Password.new(password_hash)
  end

  def gmail_password=(new_password)
    @gmail_password = Password.create(new_password)
    self.password_hash = @gmail_password
  end
end
