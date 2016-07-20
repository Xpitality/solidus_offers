class AddMainToOffers < ActiveRecord::Migration
  def change
    add_column :spree_offers, :main, :boolean, default: false
  end
end
