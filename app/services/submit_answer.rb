require_relative 'application_service'

class SubmitAnswer < ApplicationService
  ANSWER_SAVED_MESSAGE = 'Answer saved'.freeze

  def initialize(from: {}, photo: [])
    @from = from
    @photo = photo
    @current_date = Date.today
  end

  def call
    return if from.empty? || photo.empty?
    file_id = photo.last.file_id
    user = User.where(id: from[:id]).first
    date_theme = DateTheme.where(date: current_date).first
    answer = Answer.new(user_id: user.id, date_theme_id: date_theme.id, file_id: file_id)

    file_url = TelegramImagePath.call(file_id)
    score = ImageScore.call(image_url: file_url, theme: date_theme.theme)
    answer.tap { |a| a.score = score }.save
    SendMessageJob.perform_async(chat: user.id, text: ANSWER_SAVED_MESSAGE)
  end

  private
    attr_accessor :from, :photo, :current_date
end
