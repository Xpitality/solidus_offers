Deface::Override.new(
  virtual_path: 'spree/admin/shared/_menu',
  name: 'add_offers_admin_menu_tab',
  insert_bottom: '[data-hook="admin_tabs"]',
  partial: 'spree/admin/offers/tab'
)
