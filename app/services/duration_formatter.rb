class DurationFormatter
  def self.format(seconds)
    seconds = seconds.to_i
    years, remaining = seconds.divmod(31_536_000)  # 365日
    months, remaining = remaining.divmod(2_592_000)  # 30日
    days, remaining = remaining.divmod(86_400)
    hours, remaining = remaining.divmod(3600)
    minutes, seconds = remaining.divmod(60)

    parts = []
    parts << "#{years}年" if years > 0
    parts << "#{months}ヶ月" if months > 0
    parts << "#{days}日" if days > 0
    parts << "#{hours}時間" if hours > 0
    parts << "#{minutes}分" if minutes > 0
    parts << "#{seconds}秒" if seconds > 0

    parts.join(' ')
  end
end