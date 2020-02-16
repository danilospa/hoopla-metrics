module HooplaHelper
  def extract_id_from_metrics_url(url)
    url.gsub("#{HooplaClient::PUBLIC_API_ENDPOINT}#{HooplaClient::METRICS_PATH}/", '')
  end
end
