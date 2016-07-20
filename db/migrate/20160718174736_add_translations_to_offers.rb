class AddTranslationsToOffers < ActiveRecord::Migration
  def up
    unless table_exists?(:spree_offer_translations)
      params = { name: :string, slug: :string, description: :text, abstract: :text, meta_title: :string, meta_description: :text, meta_keywords: :text }
      Spree::Offer.create_translation_table!(params, { migrate_data: true })
    end
  end

  def down
    Spree::Offer.drop_translation_table! migrate_data: true
  end
end
