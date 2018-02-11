require_relative 'application_service'

class SendCurrentTheme < ApplicationService
  def initialize
    @current_date = Date.today
    @current_theme = TodayTheme.call
  end

  def call
    record = date_theme_record
    participants_ids = User.active.map(:id)
    send_theme(participants_ids, record)
  end

  private
    attr_accessor :current_theme, :current_date, :token

    def date_theme_record
      date_theme = DateTheme.new(theme: current_theme, date: current_date)
      return date_theme.tap(&:save) if date_theme.valid?

      DateTheme.first(date: current_date)
    end

    def send_theme(participants, theme_record)
      participants.each do |chat_id|
        SendMessageJob.perform_async(chat: chat_id, text: theme_record.theme)
      end
    end
end
