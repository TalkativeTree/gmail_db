class Interaction < ActiveRecord::Base
  belongs_to :employee
  belongs_to :admin

  has_many :messages, dependent: :destroy
end
