class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :get_client

  def get_client
    @hoopla_client = HooplaClient.hoopla_client
#    @descriptor = HooplaClient.client.get('/', {'Accept' => 'application/vnd.hoopla.api-descriptor+json'})
  end
end
