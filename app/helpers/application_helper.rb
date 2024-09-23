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

  # 禁煙記録の期間をフォーマット
  def format_duration(from_time, to_time = Time.current)
    duration = to_time - from_time
    years, remaining = duration.divmod(1.year)
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

  # サイドバーのアクティブリンクを判定
  def calculate_savings(seconds, daily_potential_savings)
    (daily_potential_savings * seconds / 1.day).round(0)
  end

  def total_savings
    completed_savings = current_user.quit_smoking_records.completed.sum(:money_saved)
    current_quit_attempt = current_user.quit_smoking_records.active.first
    current_savings = if current_quit_attempt
                        daily_savings = current_user.calculate_daily_potential_savings
                        calculate_savings(current_quit_attempt.duration, daily_savings)
                      else
                        0
                      end
    completed_savings + current_savings
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