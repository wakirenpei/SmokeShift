module ApplicationHelper
  def flash_background_color(type)
    type.to_sym == :notice ? 'bg-customForm' : 'bg-red-500'
  end

  # rubocop:disable Metrics/MethodLength
  def default_meta_tags
    {
      site: 'Smoke Shift',
      title: '喫煙、禁煙の記録を行うサービス',
      reverse: true,
      charset: 'utf-8',
      description: '実際の喫煙データがあるからこそ、その時の自分に合った禁煙プランを。短期の節約目的から完全な禁煙まで、あなたのペースで',
      keywords: '禁煙,禁煙アプリ,禁煙サポート,節約,喫煙記録',
      canonical: request.original_url,
      separator: '|',
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: request.original_url,
        local: 'ja-JP'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@obvyamdrss',
        image: image_url('ogp.png')
      }
    }
  end
  # rubocop:enable Metrics/MethodLength

  # 禁煙記録の期間をフォーマット
  def format_duration(input, end_time = nil)
    seconds = calculate_seconds(input, end_time)
    return '0秒' if seconds <= 0

    parts = build_duration_parts(seconds)
    parts.join(' ')
  end

  def total_savings
    current_user.quit_smoking_records.sum(&:calculate_savings)
  rescue StandardError
    0
  end

  def total_smoking_amount
    current_user.smoking_records.sum(:price_per_cigarette)
  rescue StandardError
    0
  end

  def smoking_savings_difference
    total_savings - total_smoking_amount
  rescue StandardError
    0
  end

  private

  def calculate_seconds(input, end_time)
    if end_time.present?
      (end_time - input).to_i
    elsif input.is_a?(Integer)
      input
    else
      (Time.current - input).to_i
    end
  end

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def build_duration_parts(seconds)
    years, remaining = seconds.divmod(1.year)
    months, remaining = remaining.divmod(1.month)
    days, remaining = remaining.divmod(1.day)
    hours, remaining = remaining.divmod(1.hour)
    minutes, seconds = remaining.divmod(1.minute)

    parts = []
    parts << "#{years}年" if years.positive?
    parts << "#{months}ヶ月" if months.positive?
    parts << "#{days}日" if days.positive?
    parts << "#{hours}時間" if hours.positive?
    parts << "#{minutes}分" if minutes.positive?
    parts << "#{seconds.to_i}秒"
    parts
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
