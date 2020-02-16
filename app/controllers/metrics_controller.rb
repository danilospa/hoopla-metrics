class MetricsController < ApplicationController
  include HooplaHelper

  def index
    @metrics = @hoopla_client.metrics.map { |m| m.merge(id: extract_id_from_metrics_url(m[:href])) }
  end
end
