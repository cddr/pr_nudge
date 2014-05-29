require 'spec_helper'

describe GithubWebhook, :type => :model do
  describe '.parse_and_build_from_json' do
    before(:all) do
      @push = GithubWebhook::PUSH
      @events = {}.with_indifferent_access
      GithubWebhook::PR_WORKFLOW_EVENTS.each do |event|
        file = Rails.root.join(*%W(spec support fixtures #{event}.json))
        @events[event] = JSON.parse(File.read(file))
      end
    end

    it 'sets the github_event' do
      gw = GithubWebhook.parse_and_build_from_json(@push, {})

      expect(gw.github_event).to eq 'push'
    end

    describe 'name parsing' do
      it "parses out username from each payload" do
        @events.each do |event, payload|
          gw = GithubWebhook.parse_and_build_from_json(event, payload)
          expect(gw.username).to eq 'montague'
        end
      end
    end

    describe 'event parsing' do
      it 'parses out pr_workflow_event each payload' do
        @events.each do |event, payload|
          gw = GithubWebhook.parse_and_build_from_json(event, payload)
          expect(gw.pr_workflow_event).to eq event
        end
      end
    end
  end
end
