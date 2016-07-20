module Spree
  module Admin
    class OfferImagesController < ResourceController
      before_action :load_data

      create.before :set_viewable
      update.before :set_viewable

      def index
      end

      private

      def model_class
        Spree::OfferImage
      end

      def location_after_destroy
        admin_offer_images_url(@offer)
      end

      def location_after_save
        admin_offer_images_url(@offer)
      end

      def load_data
        @offer = Spree::Offer.friendly.find(params[:offer_id])
      end

      def set_viewable
        @offer_image.viewable_type = 'Spree::Offer'
        @offer_image.viewable_id = params[:offer_image][:offer_id]
      end
    end
  end
end
