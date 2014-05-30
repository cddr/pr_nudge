class PagesController < ApplicationController
  def status
    @report = GithubWebhook.report
  end
end
