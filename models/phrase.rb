class Phrase < ActiveRecord::Base
  has_many :words, dependent: :destroy
end