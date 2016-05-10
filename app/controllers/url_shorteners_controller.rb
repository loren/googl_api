class UrlShortenersController < ApplicationController
  RETRY_INTERVAL_SECONDS = 30
  RETRY_COUNT = 3

  rescue_from(ActionController::ParameterMissing) do |e|
    render json:   { error:  { missing_parameters: e.param } },
           status: :bad_request
  end

  def shorten
    shortener = UrlShortener.new(params.require(:url),
                                 params.fetch(:retry_count, RETRY_COUNT),
                                 params.fetch(:retry_interval_seconds, RETRY_INTERVAL_SECONDS))
    shortener_response = shortener.shorten
    render json: shortener_response
  end
end
