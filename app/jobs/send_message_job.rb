class SendMessageJob
  include SuckerPunch::Job

  def perform(chat:, text:)
    SendMessage.call(chat: chat, text: text)
  end
end
