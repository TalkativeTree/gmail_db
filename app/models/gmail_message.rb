class GmailMessage < ActiveRecord::Base
  has_many :parts
end
