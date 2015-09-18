module Avatarable
  extend ActiveSupport::Concern

  included do
    avatar_styles = {
      large:      "150x150>",
      medium:     "100x100>",
      dagschotel: "80x80>",
      small:      "40x40>"
    }

    has_attached_file :avatar, styles: avatar_styles, default_style: :medium

    validates_attachment :avatar,
      presence: true,
      content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }
  end
end
