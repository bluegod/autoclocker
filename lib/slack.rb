# frozen_string_literal: true

require 'httparty'

class Slack
  CouldNotPostError = Class.new(StandardError)

  WEBHOOK_URL = 'https://hooks.slack.com/services/'

  def initialize
    @name = slack_user
    @url = WEBHOOK_URL + Config.instance.slack_token
  end

  attr_writer :name

  def clock_in
    fire_hook("#{@name} clocked in at work.")
  end

  def clock_out
    fire_hook("#{@name} clocked out at work.")
  end

  def clock_in_error(message)
    fire_hook("#{slack_user} could not clock in.", attachment: message)
  end

  def clock_out_error(message)
    fire_hook("#{slack_user} could not clock out.", attachment: message)
  end

  def other_error(message)
    fire_hook("#{slack_user} an error occurred!", attachment: message)
  end

  private

  def slack_user
    @slack_user ||= "@#{Config.instance.default.slack_user}"
  end

  def fire_hook(text, attachment: nil, channel: Config.instance.default.slack_channel)
    body = { text: text, link_names: 1 }
    body[:channel] = channel
    body[:attachments] = [{ text: attachment, color: 'danger' }] if attachment
    response = HTTParty.post(@url, body: body.to_json)

    raise CouldNotPostError, response.inspect unless response.code == 200
  end
end
