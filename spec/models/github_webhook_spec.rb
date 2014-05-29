require 'spec_helper'

describe GithubWebhook, :type => :model do
  describe '.parse_and_build_from_json' do
    before(:all) do
      @events = {}
      GithubWebhook::PR_WORKFLOW_EVENTS.each do |event|
        file = Rails.root.join(*%W(spec support fixtures #{event}.json))
        @events[event] = JSON.parse(File.read(file))
      end
    end

    context 'push' do
      it 'parses a merge event' do
        gw = GithubWebhook.parse_and_build_from_json(@events[:merge])
        expect(gw.pr_workflow_event).to eq GithubWebhook::PR_MERGE
      end
    end
  end
end
