module GithubWebhooksHelper

  def link_to_github_profile_for(username)
    link_to username, "https://github.com/#{username}"
  end

  def formatted_time_in_colored_table_cell(time)
    return content_tag :span, "No Data", style: "background-color: rgba(255,0,0,0.8)", class: 'label' if time.nil?
    hours_since_last_action = ((Time.now.utc - time.utc) / 1.hour).round * 5
    if hours_since_last_action > 255
      green = 0
      red = 255
    else
      green = 255 - hours_since_last_action
      red = hours_since_last_action
    end
    style = "background-color: rgba(#{red},#{green},0,0.8)"
    content_tag :span, "#{time_ago_in_words(time)} ago", style: style, class: 'label'
  end
end
