module Slack
  class Mailer
    class Configuration

      attr_accessor :templates_path, :templates_type, :erb_in_templates, :slack_hook_urls

      def initialize
        @templates_path = nil
        @templates_type = nil
        @erb_in_templates = false
        @slack_hook_urls = nil
      end

      def self.config
        @configuration ||= Slack::Mailer::Configuration.new
      end

      def self.reset
        @configuration = Slack::Mailer::Configuration.new
      end

      def self.configure
        yield(config)
      end
    end
  end
end
