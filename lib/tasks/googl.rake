desc 'See Goo.gl rate limiting and retry in action'
namespace :googl do
  task :exceed_rate_limit, [:base_url] => :environment do |_t, args|
    puts "Tail your #{Rails.env}.log file to see results. Ctrl-C to interrupt this task."
    idx = 1
    retries = 10
    interval = 3
    while true do
      shortener = UrlShortener.new("#{args.base_url}#{ idx +=1 }", retries, interval)
      shortener_response = shortener.shorten
      Rails.logger.info shortener_response.as_json
    end
  end
end
