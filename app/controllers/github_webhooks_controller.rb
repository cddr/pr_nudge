class GithubWebhooksController < ApplicationController
  def ping
    render json: {
      status: :ok
    }, status: :ok
  end

  def payload
    event = request.headers['X-GitHub-Event']
    push = JSON.parse(params[:github_webhook].to_json)
    puts "I got some JSON: #{push.inspect}"
    puts "EVENT WAS: #{event}"
    render json: push
  end

  private
  def listen_for
    %w(pull_request pull_request_review_comment)
  end
end
