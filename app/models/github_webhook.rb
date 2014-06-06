class GithubWebhook < ActiveRecord::Base
  USERNAMES = %w(montague jmpage JHilker cmcn cddr gl0ng dougo sosubramanian bosoxbill)

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

  validates :username, :pr_workflow_event, :github_event, presence: true

  def self.parse_and_build_from_json(github_event, payload)
    new(github_event: github_event, payload: payload).tap do |gw|
      gw.parse_and_set_fields
    end
  end

  def parse_and_set_fields
    self.username = parse_username
    self.pr_workflow_event = parse_pr_workflow_event
  end

  def self.report
    # TODO refactor this shit
    # name
    # last pr merged(w/colored background)
    # last code review comment made
    {}.tap do |report|
      USERNAMES.each {|username| report[username] = {}}
      GithubWebhook.where(pr_workflow_event: [:pr_comment, :pr_code_review_comment]).group(:username).maximum(:created_at).each do |username, time|
        report[username].merge!(last_pr_comment: time) if USERNAMES.include?(username)
      end
      GithubWebhook.where(pr_workflow_event: :pr_merge).group(:username).maximum(:created_at).each do |username, time|
        report[username].merge!(last_pr_merged: time) if USERNAMES.include?(username)
      end
      GithubWebhook.where(pr_workflow_event: [:pr_comment, :pr_code_review_comment]).group(:username).count.each do |username, total|
        report[username].merge!(total_pr_comments: total) if USERNAMES.include?(username)
      end
      GithubWebhook.where(pr_workflow_event: :pr_merge).group(:username).count.each do |username, total|
        report[username].merge!(total_prs_merged: total) if USERNAMES.include?(username)
      end
      USERNAMES.each do |username|
        %i(total_prs_merged total_pr_comments).each do |event|
          report[username][event] ||= 0
        end
      end
    end
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
end
