# SlackMailer
SlackMailer gem helps separate business logic from logic of message delivery. It structures code just like ActionMailer.

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

Before using gem you need install [sidekiq](https://github.com/mperham/sidekiq) in to your project.

## Configuring

Add queue for sidekiq to config/sidekiq.yml

```yml
- [slack_messages, 1]
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
Gem balances messages by hooks. It helps not to reach a message limit through 1 hook per 1 second.

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

If you want to send a message via Mailer without sidekiq
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

 Sending message by passing sidekiq
```ruby
Slack::Mailer.send_direct_message('#channel', 'name', 'message')
```
Also you can do this by using [slack-notifier](https://github.com/stevenosloan/slack-notifier)
