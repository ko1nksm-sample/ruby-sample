class Detail < ApplicationRecord
  belongs_to :order, required: false

  validates :product, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
end
