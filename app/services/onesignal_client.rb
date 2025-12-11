require 'net/http'
require 'uri'
require 'json'

class OneSignalClient
  class Error < StandardError; end

  def self.create_notification(payload)
    uri = URI.parse("#{ONESIGNAL_API_URL}/notifications")
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json;charset=utf-8"
    request["Authorization"] = "Basic #{ONESIGNAL_REST_API_KEY}"
    request.body = payload.to_json

    resp = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    unless resp.is_a?(Net::HTTPSuccess)
      raise Error, "OneSignal error: #{resp.code} #{resp.body}"
    end

    JSON.parse(resp.body)
  end
end