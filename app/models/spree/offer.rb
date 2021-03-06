module Spree
  class Offer < Spree::Base
    extend FriendlyId
    friendly_id :slug_candidates, use: :history

    has_many :images, -> { order(:position) }, class_name: 'Spree::OfferImage', as: :viewable, dependent: :destroy

    belongs_to :taxon, class_name: 'Spree::Taxon'

    validates :meta_keywords, length: { maximum: 255 }
    validates :meta_title, length: { maximum: 255 }
    validates :name, presence: true
    validates :taxon_id, presence: true
    validates :discount, numericality: { only_integer: true, greater_than: -1, less_than: 100 }
    validates :slug, length: { minimum: 3 }, uniqueness: { allow_blank: true }

    self.whitelisted_ransackable_associations = %w[stores images]
    self.whitelisted_ransackable_attributes = %w[slug]

    class << self
      def active
        where(active: true)
      end

      def main
        where(main: true)
      end

      def secondary
        where(main: false)
      end

      def with_discount
        where('discount > 0')
      end

      def without_discount
        where(discount: 0)
      end
    end

    def display_image
      images.first || Spree::OfferImage.new
    end

    private

    def slug_candidates
      [:name]
    end

  end
end