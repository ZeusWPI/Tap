# == Schema Information
#
# Table name: products
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  price_cents         :integer          default(0), not null
#  created_at          :datetime
#  updated_at          :datetime
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#  category            :integer          default(0)
#  stock               :integer          default(0), not null
#  calories            :integer
#  deleted             :boolean          default(FALSE)
#

module ProductsHelper
  def kcal(calories)
    calories.to_s + " kcal"
  end

  def kcal_tag(calories)
    if calories
      content_tag :small, kcal(calories)
    else
      '&nbsp;'.html_safe
    end
  end
end
