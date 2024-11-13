module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :notice then 'bg-customForm'
    when :alert then 'bg-red-500'
    when :error then 'bg-red-500'
    else 'bg-customForm'
    end
  end

  # 禁煙記録の期間をフォーマット
  def format_duration(input, end_time = nil)
    seconds = case
              when end_time.present?
                # 履歴表示用（2つの時間）
                (end_time - input).to_i
              when input.is_a?(Integer)
                # 秒数直接指定（総禁煙時間用）
                input
              else
                # 現在までの経過時間
                (Time.current - input).to_i
              end

    return "0秒" if seconds <= 0

    years, remaining = seconds.divmod(1.year)
    months, remaining = remaining.divmod(1.month)
    days, remaining = remaining.divmod(1.day)
    hours, remaining = remaining.divmod(1.hour)
    minutes, seconds = remaining.divmod(1.minute)

    parts = []
    parts << "#{years}年" if years > 0
    parts << "#{months}ヶ月" if months > 0
    parts << "#{days}日" if days > 0
    parts << "#{hours}時間" if hours > 0
    parts << "#{minutes}分" if minutes > 0
    parts << "#{seconds.to_i}秒"

    parts.join(' ')
  end

  def total_savings
    current_user.quit_smoking_records.sum(&:calculate_savings)
  rescue
    0
  end

  def total_smoking_amount
    current_user.smoking_records.sum(:price_per_cigarette)
  rescue
    0
  end

  def smoking_savings_difference
    total_savings - total_smoking_amount
  rescue
    0
  end
end