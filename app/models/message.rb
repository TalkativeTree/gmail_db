class Message < ActiveRecord::Base
  belongs_to :interaction
  has_many   :parts, dependent: :destroy
end
