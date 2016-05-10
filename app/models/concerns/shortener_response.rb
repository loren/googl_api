class ShortenerResponse
  attr_reader :message, :canonical_url, :short_url

  def initialize(message:, canonical_url:, short_url:)
    @message, @canonical_url, @short_url = message, canonical_url, short_url
  end
end