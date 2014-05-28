class GithubWebhooksController < ApplicationController
  def ping
    render json: {
      status: :ok
    }, status: :ok
  end

  def payload
    push = JSON.parse(params[:github_webhook].to_json)
    puts "I got some JSON: #{push.inspect}"
    render json: push
  end
end
