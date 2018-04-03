require_relative 'configuration'
require 'slack-notifier'
require 'sidekiq'

module Slack
  class Mailer
    class DeliveryWorker
      include Sidekiq::Worker
      sidekiq_options queue: :slack_messages
      sidekiq_options retry: Proc.new{ Slack::Mailer::Configuration.config.slack_hook_urls.length }, dead: false
      sidekiq_retry_in { 1 }
      sidekiq_retries_exhausted do |msg|
        Slack::Mailer::DeliveryWorker.perform_async(msg['args'][0])
      end

      attr_accessor :name, :channel, :message, :retry_count

      def retry_count
        @retry_count || 0
      end

      def perform(params)
        params.each{ |attribute, value| send("#{attribute}=", value) if respond_to?(attribute) }
        Slack::Notifier.new(Slack::Mailer.slack_hook_url, username: name, channel: channel, link_names: 1).ping(message)
      end
    end
  end
end
