class GmailMessage < ActiveRecord::Base
  has_many :parts
  belongs_to :admin

  scope :sent_by, ->(user){ where(from: user.email) }

  def body
    parts.select{|part| part.content.include?("MIME-Version: 1.0")}[0].content
  end
end
