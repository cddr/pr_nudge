module GithubWebhooksHelper
  def formatted_time_ago(time)
    return 'No Data' if time.nil?
    time_ago_in_words(time)
  end
end
