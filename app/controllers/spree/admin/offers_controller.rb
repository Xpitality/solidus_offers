module Spree
  module Admin
    class OffersController < ResourceController

      before_action :available_taxons, only: [:index, :new, :edit]

      def index
        respond_with(@collection) do |format|
          format.html
        end
      end

      def show
        redirect_to edit_admin_offer_path(@offer)
      end

      def create
        @offer = Spree::Offer.new(offer_params)
        if @offer.save

          flash[:success] = Spree.t(:created_successfully)
          redirect_to edit_admin_offer_url(@offer)
        else
          render :new, status: :unprocessable_entity
        end
      end

      private

      def find_resource
        Spree::Offer.friendly.find(params[:id])
      end

      def collection
        return @collection if @collection.present?
        if request.xhr? && params[:q].present?
          @collection = Spree::Offer
          .where("spree_offers.title #{LIKE} :search",
                 { search: "#{params[:q].strip}%" })
          .limit(params[:limit] || 100)
        else
          @search = Spree::Offer.ransack(params[:q])
          @collection = @search.result.page(params[:page]).per(Spree::Config[:admin_products_per_page])
        end
      end

      def offer_params
        attributes = [:name, :abstract, :description, :meta_title, :meta_description, :meta_keywords,
                      :slug, :discount, :active, :main, :taxon_id]

        params.require(:offer).permit(attributes)
      end

      def available_taxons
        taxon_hash = {}
        @taxons = Spree::Taxon.all.order(:taxonomy_id, :lft).map do |t|
          if t.parent_id.nil?
            taxon_hash[t.id] = t.name
          else
            taxon_hash[t.id] = "#{taxon_hash[t.parent_id]} > #{t.name}"
          end
          [t.id, taxon_hash[t.id]]
        end
      end
    end
  end
end