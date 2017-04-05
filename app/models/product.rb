class Product < ApplicationRecord
  validates :title, :description, :image_url, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
      with: %r{\.(gif|jpg|png)\Z}i,
      message: 'URL must direct for image format GIF, JPG, PNG.'
  }

  def self.latest
    Product.order(:updated_at).last
  end

  has_many :line_items
  has_many :orders, through: :line_items
  before_destroy :ensure_not_references_by_any_line_item

  private

  def ensure_not_references_by_any_line_item
    if line_items.empty?
      return true
    else
      errors.add(:base, 'exist the goods positions')
      return false
    end
  end
end
