require 'rails_helper'

RSpec.feature "UrlShorteners", type: :feature do
  scenario 'successfully shortening a URL' do
    old_key = ENV['GOOGL_API_KEY']
    ENV['GOOGL_API_KEY'] = 'test_key'
    VCR.use_cassette('googl url shortener') do
      visit '/shorten?url=http://www.google.com/test%20case&retry_count=2&retry_interval_seconds=30'
      expect(page.status_code).to eq(200)

      parsed_response = JSON.parse(page.body)
      expect(parsed_response['message']).to eq('OK')
      expect(parsed_response['canonical_url']).to eq('http://www.google.com/test%20case')
      expect(parsed_response['short_url']).to eq('http://goo.gl/el3BPF')
    end
    ENV['GOOGL_API_KEY'] = old_key
  end

  scenario 'url parameter missing' do
    visit '/shorten'
    expect(page.status_code).to eq(400)

    parsed_response = JSON.parse(page.body)
    expect(parsed_response['error']['missing_parameters']).to eq('url')
  end

end
