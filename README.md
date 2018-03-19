# SlackMailer

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slack_mailer'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install slack_mailer
## Dependencies

Before using game you need install [sidekiq](https://github.com/mperham/sidekiq) in to your project.

## Configuring

Add queue for sidekiq in to config/sidekiq.yml

```yml
- [slack_messages, 1]
```

Configure sidekiq retries in config/initializers/sidekiq.rb
```ruby
class SidekiqMiddleware
  def call(worker, msg, _queue)
    worker.retry_count = msg['retry_count'] if worker.respond_to?(:retry_count)
    yield
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add SidekiqMiddleware
  end
end
```

Create configuration file config/initializers/slack_mailer.rb

```ruby
Slack::Mailer::Configuration.configure do |config|
  config.templates_path = "#{Rails.root}/app/views/slack_templates/"
  config.templates_type = 'text'
  config.erb_in_templates = true
  config.slack_hook_urls = ['https://hooks.slack.com/services/...........',
                            'https://hooks.slack.com/services/...........']
end
```

## Usage

app/slack_mailers/user_mailer.rb

```ruby
class UserMailer < Slack::Mailer

  def created(user)
    @user = user
    mail(to: 'channel_name', template: 'created')
  end

end
```

If you want to send message via Mailer without sidekiq
```ruby
class UserMailer < Slack::Mailer

  def created(user)
    @user = user
    mail(to: 'channel_name', template: 'created', use_sidekiq: false)
  end

end
```

Mailer will be using template *app/views/slack_templates/user_mailer/created.text.erb*

```text
Name: <%= @user.name %>
Full name: <%= @user.full_name %>
Phone: <%= @user.phone %>
```
#### Sending messages
```ruby
UserMailer.created(user)
```

Sending small messages(one line message)
```ruby
Slack::Mailer.send_message('#channel', 'name', 'message')
```

Sending message bypassing sidekiq
```ruby
Slack::Mailer.send_direct_message('#channel', 'name', 'message')
```
Also you can do this by using [slack-notifier](https://github.com/stevenosloan/slack-notifier)
