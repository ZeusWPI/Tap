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
