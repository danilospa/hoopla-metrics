class MetricValuesController < ApplicationController
  def index
    metric_values = @hoopla_client.metric_values(params[:id])
    @users = @hoopla_client.users.map do |user|
      metric_value = metric_values.find { |v| v[:owner][:href] == user[:href] }
      user.merge(metric_value: metric_value ? metric_value[:value] : 0)
    end
  end
end
