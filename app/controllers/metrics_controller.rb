class MetricsController < ApplicationController
  def index
    @metrics = @hoopla_client.metrics
  end
end
