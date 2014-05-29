class GithubWebhook < ActiveRecord::Base
  USERNAMES = %w(
  montague
  jmpage
  jhilker
  cmcn
  cddr
  gl0ng
  dougo
  sosubramanian
  )
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

  def self.parse_and_build_from_json(github_event, payload)
    new(github_event: github_event, payload: payload).tap do |gw|
      gw.parse_and_set_fields
    end
  end

  def parse_and_set_fields
    self.username = parse_username
    self.pr_workflow_event = parse_pr_workflow_event
  end

  private
  def parse_username
    return payload['sender']['login'] if payload.key?('sender')
    return payload['pusher']['name'] if payload.key?('pusher')
  end

  def parse_pr_workflow_event
    return PR_OPEN if payload['action'] == 'opened'
    return PR_MERGE if payload['pull_request'] && payload['pull_request']['merged'] == true
    return PR_DELETE if payload['deleted'] == true
    return PR_COMMENT if payload['issue'] && payload['comment']
    return PR_CODE_REVIEW_COMMENT if payload['comment']
  end

  def merged?
    return false unless payload['action'] == 'closed'

  end
end
