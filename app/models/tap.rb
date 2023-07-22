class Tap < ApplicationRecord
  has_one_attached :file
  has_many :call_details
end
