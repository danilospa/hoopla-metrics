require 'faraday'
require 'faraday_middleware'

class HooplaClient
  CLIENT_ID = ENV['CLIENT_ID']
  CLIENT_SECRET = ENV['CLIENT_SECRET']
  PUBLIC_API_ENDPOINT = 'https://api.hoopla.net'
  METRICS_PATH = '/metrics'
  METRIC_VALUES_PATH = "#{METRICS_PATH}/:ID/values"
  USERS_PATH = '/users'

  def initialize
    descriptor
  end

  def self.hoopla_client
    @@hoopla_client_singleton ||= HooplaClient.new
  end

  def metrics
    get(METRICS_PATH)
  end

  def metric_values(metric_id)
    get(METRIC_VALUES_PATH.gsub(':ID', metric_id))
  end

  def metric_value(metric_id, id)
    get("#{metric_values_path(metric_id)}/#{id}")
  end

  def create_metric_value(metric_id, metric_value)
    post(metric_values_path(metric_id), metric_value)
  end

  def update_metric_value(metric_id, id, metric_value)
    put("#{metric_values_path(metric_id)}/#{id}", metric_value)
  end

  def users
    get(USERS_PATH)
  end

  def get(relative_url, headers = nil)
    response = client.get(relative_url, headers)
    parse_response(response)
  end

  def post(relative_url, data, headers = {})
    response = client.post(relative_url, data.to_json, headers.merge('content-type':'application/vnd.hoopla.metric-value+json'))
    parse_response(response)
  end

  def put(relative_url, data, headers = {})
    response = client.put(relative_url, data.to_json, headers.merge('content-type':'application/vnd.hoopla.metric-value+json'))
    parse_response(response)
  end

  def get_relative_url(link)
    descriptor['links'].find { |l| l['rel'] == link }['href'].delete_prefix descriptor['href']
  end

  private

  def connection
    @conn ||= Faraday.new(url: PUBLIC_API_ENDPOINT) do |faraday|
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
      faraday.basic_auth CLIENT_ID, CLIENT_SECRET
    end
  end

  def login
    response = connection.post('oauth2/token') do |req|
      if @refresh_token
        req.params['grant_type'] = 'refresh_token'
        req.params['refresh_token'] = @refresh_token
      else
        req.params['grant_type'] = 'client_credential'
      end
    end

    if response.status == 200
      json_resp = JSON.parse(response.body)
      @token = json_resp['access_token']
      @refresh_token = json_resp['refresh_token']
    else
      if (@token.nil? && @refresh_token.nil?)    # Nothing to retry
        raise ActiveResource::UnauthorizedAccess
      else
        @token = nil
        @refresh_token = nil
      end
    end
    @token
  end

  def token
    if !@token
      login

      if !@token # login failed
        login
      end

      # Either it's succeeded or raised an execption
    end
    @token
  end

  def client
    @client ||= Faraday.new(url: PUBLIC_API_ENDPOINT) do |faraday|
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
      faraday.use FaradayMiddleware::EncodeJson
      faraday.authorization :Bearer, token
    end
  end

  def parse_response(response)
    if [200, 201].include? response.status
      body = JSON.parse(response.body)
      body.is_a?(Array) ? body.map(&:deep_symbolize_keys) : body.deep_symbolize_keys
    else
      raise StandardError('Invalid response: #{response.status}: #{response.body')
    end
  end

  def descriptor
    descriptor_url = PUBLIC_API_ENDPOINT
    @descriptor ||= self.get(descriptor_url, {'Accept' => 'application/vnd.hoopla.api-descriptor+json'})
  end

  def metric_values_path(metric_id)
    METRIC_VALUES_PATH.gsub(':ID', metric_id)
  end
end
