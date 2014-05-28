class GithubWebhooksController < ApplicationController
  skip_before_action  :verify_authenticity_token
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
  def listener_for(event)
    # pull_request, push happens on merge
    # delete to delete a branch
    #%w(pull_request pull_request_review_comment issue_comment)
    {
      'pull_request' => 'A PULL REQUEST WAS OPENED!!',
      'pull_request_review_comment' => 'A COMMENT WAS MADE ON YOUR PR!',
      'issue_comment' => 'SOMEONE COMMENTED ON YOUR OPEN PR'
    }
  end
end
