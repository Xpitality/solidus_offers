module Spree
  class Offer < Spree::Base
    extend FriendlyId
    friendly_id :slug_candidates, use: :history

    # solidus_globalize
    translates :name, :slug, :description, :abstract, :meta_title, :meta_description, :meta_keywords,
               fallbacks_for_empty_translations: true
    include SolidusGlobalize::Translatable

    has_many :images, -> { order(:position) }, class_name: 'Spree::offerImage', as: :viewable, dependent: :destroy

    belongs_to :taxon, class_name: 'Spree::Taxon'

    validates :meta_keywords, length: { maximum: 255 }
    validates :meta_title, length: { maximum: 255 }
    validates :name, presence: true
    validates :discount, numericality: { only_integer: true, greater_than: 0, less_than: 100 }
    validates :slug, length: { minimum: 3 }, uniqueness: { allow_blank: true }

    self.whitelisted_ransackable_associations = %w[stores images]
    self.whitelisted_ransackable_attributes = %w[slug]

    private

    def slug_candidates
      [
        :name,
        [:name, :city]
      ]
    end

  end
end