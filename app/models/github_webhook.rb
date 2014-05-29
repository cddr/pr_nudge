class GithubWebhook < ActiveRecord::Base
  GITHUB_EVENTS = %w(
                push pull_request_review_comment
                issue_comment commit_comment
                pull_request delete
  )
  GITHUB_EVENTS.each do |event|
    const_set(event.upcase, event)
  end

  PR_WORKFLOW_EVENTS = %w(pr_open pr_merge pr_delete pr_comment pr_code_review_comment)
  PR_WORKFLOW_EVENTS.each do |event|
    const_set(event.upcase, event)
  end

  def self.parse_and_build_from_json(json)
    gw = new(payload: json)
  end
end
