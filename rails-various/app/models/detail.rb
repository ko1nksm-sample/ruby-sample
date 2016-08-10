class Detail < ApplicationRecord
  belongs_to :order, required: false
end
