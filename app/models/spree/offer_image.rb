module Spree
  class OfferImage < Asset
    validate :no_attachment_errors

    has_attached_file :attachment,
                      styles: { mini: '48x48>', small: '100x100>', r4x3: '800x600#',  r13x5: '1170x450#', r16x9: '942x530#' },
                      default_style: :offer,
                      default_url: 'noimage/:style.png',
                      url: '/spree/offers/:id/:style/:basename.:extension',
                      path: ':rails_root/public/spree/offers/:id/:style/:basename.:extension',
                      convert_options: { all: '-strip -auto-orient -colorspace sRGB' }
    validates_attachment :attachment,
      presence: true,
      content_type: { content_type: %w(image/jpeg image/jpg image/png image/gif) }

    # save the w,h of the original image (from which others can be calculated)
    # we need to look at the write-queue for images which have not been saved yet
    after_post_process :find_dimensions

    # used by admin offers autocomplete
    def mini_url
      attachment.url(:mini, false)
    end

    def find_dimensions
      temporary = attachment.queued_for_write[:original]
      filename = temporary.path unless temporary.nil?
      filename = attachment.path if filename.blank?
      geometry = Paperclip::Geometry.from_file(filename)
      self.attachment_width  = geometry.width
      self.attachment_height = geometry.height
    end

    # if there are errors from the plugin, then add a more meaningful message
    def no_attachment_errors
      unless attachment.errors.empty?
        # uncomment this to get rid of the less-than-useful interim messages
        # errors.clear
        errors.add :attachment, "Paperclip returned errors for file '#{attachment_file_name}' - check ImageMagick installation or image source file."
        false
      end
    end
  end
end