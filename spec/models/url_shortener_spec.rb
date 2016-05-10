require 'rails_helper'

RSpec.describe UrlShortener, type: :model do
  it 'retries on failure' do
    expect(Googl).to receive(:shorten).twice.and_raise(Googl::Error)
    expect(Googl).to receive(:shorten).and_return(instance_double(Googl::Shorten, long_url: 'long', short_url: 'short'))
    url_shortener = UrlShortener.new('http://www.my.url/', 2, 0)
    response = url_shortener.shorten
    expect(response.short_url).to eq('short')
    expect(response.canonical_url).to eq('long')
  end

  it 'gives up after specified number of retries' do
    expect(Googl).to receive(:shorten).twice.and_raise(Googl::Error)
    url_shortener = UrlShortener.new('http://www.my.url/', 1, 0)
    response = url_shortener.shorten
    expect(response.short_url).to be_nil
    expect(response.canonical_url).to eq('http://www.my.url/')
  end
end
