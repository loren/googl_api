# README

[![Code Climate](https://codeclimate.com/repos/573380500356a548fd0024e3/badges/4d671a986861b5a23518/gpa.svg)](https://codeclimate.com/repos/573380500356a548fd0024e3/feed)
[![Test Coverage](https://codeclimate.com/repos/573380500356a548fd0024e3/badges/4d671a986861b5a23518/coverage.svg)](https://codeclimate.com/repos/573380500356a548fd0024e3/coverage)
[![Build Status](https://travis-ci.org/GovWizely/googl_api.svg?branch=master)](https://travis-ci.org/GovWizely/googl_api/)

This project provides a JSON API service around [Google's URL Shortener service](https://developers.google.com/url-shortener/) at [goo.gl](goo.gl). It has a configurable retry mechanism to transparently 
work around goo.gl's rate limiting. The idea is to call this service instead of goo.gl when you want a
shortened URL and don't mind waiting a bit for an answer.

## Dependencies

- Ruby 2.3
- Bundler 1.12
- [Google API Key](https://developers.google.com/url-shortener/v1/getting_started#APIKey) 

## Configuration & Setup

Set the `GOOGL_API_KEY` environment variable with your Google API key. For basic development/testing, you
can do something like this:

    export GOOGL_API_KEY=your_api_key_here
    
Install the gems:
    
    bundle install
    
Start the Rails application:
    
    bundle exec rails s Puma

## Sample requests

Shorten a URL, retrying up to 3 times with 30 seconds in between attempts:

    http://localhost:3000/shorten?url=http://www.some.url
    
Shorten a URL, retrying twice with 15 seconds in between attempts:

    http://localhost:3000/shorten?url=http://www.some.url&retry_count=2&retry_interval_seconds=15
    
## Triggering retries
    
If you want to test triggering goo.gl's rate limit (or handling other errors that may occur), there's a
simple rake task included:

    bundle exec rake googl:exceed_rate_limit[http://www.some_base_url.co/]

## How to run the test suite

    bundle exec rake
