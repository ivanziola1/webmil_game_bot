require_relative 'application_service'

class SendMessage < ApplicationService
  def initialize(chat: nil, text: '')
    @chat = chat
    @text = text
    @token = ENV['TELEGRAM_TOKEN']
  end

  def call
    return if chat.nil? || text.empty? || token.nil?
    Telegram::Bot::Client::run(token) do |bot|
      bot.api.send_message(chat_id: chat, text: text)
    end
  end

  private
    attr_accessor :chat, :text, :token
end
