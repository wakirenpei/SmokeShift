module ApplicationHelper
  # フラッシュメッセー時の色を指定
  def flash_background_color(type)
    case type.to_sym
    when :notice then 'bg-customForm'
    when :alert then 'bg-red-500'
    when :error then 'bg-red-500'
    else 'bg-customForm'
    end
  end
end