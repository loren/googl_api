require 'rails_helper'

RSpec.describe UrlShortener, type: :model do
  it 'retries on rate limit failure' do
    expect(Googl).to receive(:shorten).twice.and_raise(Googl::Error.new({"error"=>{"errors"=>[{"domain"=>"usageLimits", "reason"=>"rateLimitExceeded", "message"=>"Rate Limit Exceeded"}], "code"=>403, "message"=>"Rate Limit Exceeded"}}))
    expect(Googl).to receive(:shorten).and_return(instance_double(Googl::Shorten, long_url: 'long', short_url: 'short'))
    url_shortener = UrlShortener.new('http://www.my.url/', 2, 0)
    response = url_shortener.shorten
    expect(response.short_url).to eq('short')
    expect(response.canonical_url).to eq('long')
  end

  it 'does not retry on non rate limit failures' do
    expect(Googl).to receive(:shorten).once.and_raise(Googl::Error.new({"error"=>{"errors"=>[{"domain"=>"global", "reason"=>"invalid", "message"=>"Invalid Value", "locationType"=>"parameter", "location"=>"resource.longUrl"}], "code"=>400, "message"=>"Invalid Value"}}))
    url_shortener = UrlShortener.new('http://bit.ly/nope', 2, 0)
    response = url_shortener.shorten
    expect(response.short_url).to be_nil
    expect(response.canonical_url).to eq('http://bit.ly/nope')
  end

  it 'gives up after specified number of retries' do
    expect(Googl).to receive(:shorten).twice.and_raise(Googl::Error.new({"error"=>{"errors"=>[{"domain"=>"usageLimits", "reason"=>"rateLimitExceeded", "message"=>"Rate Limit Exceeded"}], "code"=>403, "message"=>"Rate Limit Exceeded"}}))
    url_shortener = UrlShortener.new('http://www.my.url/', 1, 0)
    response = url_shortener.shorten
    expect(response.short_url).to be_nil
    expect(response.canonical_url).to eq('http://www.my.url/')
  end
end
