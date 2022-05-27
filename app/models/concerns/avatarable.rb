# frozen_string_literal: true

module Avatarable
  extend ActiveSupport::Concern

  included do
    avatar_styles = {
      medium: "100x100>",
      dagschotel: "80x80>",
      small: { geometry: "40x40>", animated: false },
      koelkast: { geometry: "150x150>", animated: false }
    }

    has_attached_file :avatar, styles: avatar_styles, default_style: :medium

    validates_attachment :avatar,
                         presence: true,
                         content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }
  end
end
