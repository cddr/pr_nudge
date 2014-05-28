class GithubWebhooksController < ApplicationController
  skip_before_action  :verify_authenticity_token
  def ping
    render json: {
      status: :ok
    }, status: :ok
  end

  def payload
    # TODO create an object w/type (event header)
    # use psql json to store the payload
    event = request.headers['X-GitHub-Event']
    json = JSON.parse(params[:github_webhook].to_json)
    puts "=" * 50
    puts json
    # to differentiate:
    # branch deletion
    # branch merge into master/develop
    # pr_comment
    # pr_open
    # pr_review_comment
    #File.open("#{Rails.root}/test/fixtures/delete.json", 'w') do |f|
      #f.write params[:github_webhook].to_json
    #end
    puts "=" * 50
    puts "EVENT WAS: #{event}"
    render json: json
  end

  private
  def listener_for(event)
    # pull_request, push happens on merge
    # delete to delete a branch
    #%w(pull_request pull_request_review_comment issue_comment)
    # merged => true, merged_by => user
    {
      'pull_request' => 'A PULL REQUEST WAS OPENED!!',
      'pull_request_review_comment' => 'A COMMENT WAS MADE ON YOUR PR!',
      'issue_comment' => 'SOMEONE COMMENTED ON YOUR OPEN PR'
    }
  end
end
