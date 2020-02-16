class MetricsController < ApplicationController
  include HooplaHelper

  def index
    @metrics = @hoopla_client.metrics.map { |m| merge_id(m) }
  end
end
