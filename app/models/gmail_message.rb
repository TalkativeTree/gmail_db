class GmailMessage < ActiveRecord::Base
  has_many :parts
  belongs_to :admin
end
