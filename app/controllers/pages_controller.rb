class PagesController < ApplicationController
  def status
    @data = GithubWebhook.all
  end
end
