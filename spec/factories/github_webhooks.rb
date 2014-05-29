# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :github_webhook do
    trait :pr_open do
      github_event GithubWebhook::PULL_REQUEST
      pr_workflow_event GithubWebhook::PR_OPEN
      payload 'action' => 'opened'
    end

    trait :pr_merge do
      github_event GithubWebhook::PUSH
      pr_workflow_event GithubWebhook::PR_MERGE
      payload 'pull_request' => {'merged' => true}
    end

    trait :pr_delete do
      github_event GithubWebhook::DELETE
      pr_workflow_event GithubWebhook::PR_DELETE
      payload 'deleted' => true
    end

    trait :pr_comment do
      github_event GithubWebhook::ISSUE_COMMENT
      pr_workflow_event GithubWebhook::PR_COMMENT
      payload 'issue' => 'omg', 'comment' => 'omg'
    end

    trait :pr_code_review_comment do
      github_event GithubWebhook::PULL_REQUEST_REVIEW_COMMENT
      pr_workflow_event GithubWebhook::PR_CODE_REVIEW_COMMENT
      payload 'comment' => 'omg'
    end

    sequence(:username) { |n| "github_user_#{n}" }
  end
end
