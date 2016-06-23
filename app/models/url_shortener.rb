class UrlShortener
  def initialize(url, retry_count, retry_interval_seconds)
    @url = url
    @retry_count = retry_count.to_i
    @retry_interval_seconds = retry_interval_seconds.to_i
  end

  def shorten
    tries ||= @retry_count + 1
    googl = Googl.shorten(@url, nil, ENV['GOOGL_API_KEY'])
    ShortenerResponse.new(message: 'OK', canonical_url: googl.long_url, short_url: googl.short_url)
  rescue Googl::Error => e
    unless (tries -= 1).zero? || e.message !~ /usageLimits/
      sleep @retry_interval_seconds
      Rails.logger.warn("Retrying call for '#{@url}' (#{tries} more)")
      retry
    end
    Rails.logger.warn("Call failed for #{@url}: #{e.message}")
    ShortenerResponse.new(message: e.message, canonical_url: @url, short_url: nil)
  end
end