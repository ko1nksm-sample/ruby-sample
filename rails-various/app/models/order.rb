class Order < ApplicationRecord
   has_many :details, dependent: :destroy
   accepts_nested_attributes_for :details, allow_destroy: true

  validates :name, presence: true
  validates :address, presence: true
end
