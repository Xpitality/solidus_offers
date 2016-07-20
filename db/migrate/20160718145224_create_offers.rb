class CreateOffers < ActiveRecord::Migration
  def change
    create_table :spree_offers do |t|
      t.string :name
      t.string :slug
      t.text :abstract
      t.text :description

      t.boolean :active, default: true
      t.integer :discount, default: 0

      t.references :taxon

      t.string :meta_title
      t.string :meta_description
      t.string :meta_keywords

      t.timestamps
    end

    add_index :spree_offers, [:name], :name => 'index_spree_offers_on_name'
    add_index :spree_offers, [:slug], :name => 'index_spree_offers_on_slug', :unique => true
  end
end