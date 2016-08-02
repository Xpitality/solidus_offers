Spree::Product.class_eval do

  def offer_discount
    Spree::Offer.active.where(taxon_id: self.taxons.pluck(:id)).pluck(:discount).sort
  end

  def discount_price_for(price_options)
    # ((product_or_variant.price_for(current_pricing_options).to_d / 100.0) * (100.0 - discount.to_d)).to_s
    self.master.currently_valid_prices.detect do |price|
      discount_price = Spree::Price.new price.attributes
      discount_price.amount = discount_price.amount * (100 - offer_discount.last) / 100
      ( discount_price.country_iso == price_options.desired_attributes[:country_iso] ||
        discount_price.country_iso.nil?
      ) && discount_price.currency == price_options.desired_attributes[:currency]
      return discount_price.try!(:money)
    end.try!(:money)
  end

end