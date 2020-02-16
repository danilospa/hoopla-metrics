class MetricValuesController < ApplicationController
  include HooplaHelper

  def index
    metric_values = @hoopla_client.metric_values(params[:metric_id])
    @users = @hoopla_client.users.map do |user|
      metric_value = metric_values.find { |v| v[:owner][:href] == user[:href] }
      metric_value_with_id = if metric_value then
                               merge_id(metric_value)
                             else
                               nil
                             end
      merge_id(
        user.merge(metric_value: metric_value_with_id)
      )
    end
  end

  def show
    @metric_value = @hoopla_client.metric_value(params[:metric_id], params[:id])
  end

  def update
    metric_value = @hoopla_client.metric_value(params[:metric_id], params[:id])
    data_to_update = metric_value.merge(value: params[:value].to_f)
    @hoopla_client.update_metric_value(params[:metric_id], params[:id], data_to_update)
    redirect_to action: :show
  end
end
