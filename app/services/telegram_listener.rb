require_relative 'application_service'

class TelegramListener < ApplicationService
  SUCCESS_MESSAGE = 'You have been added to the list of participants. Expect the task.'.freeze
  ALREADY_SUBSCRIBED_MESSAGE = 'You have already been added to the list of participants.'.freeze
  ACTIVATED_MESSAGE = 'Welcome back!'.freeze
  NOT_INVITED_MESSAGE = 'In order to take part in the game write /start'.freeze
  DEACTIVATED_MESSAGE = 'Participation in the game was stopped.'.freeze
  NOT_SUPPORTED_MESSAGE = 'Not supported'.freeze
  START_COMMAND = '/start'.freeze
  MAC_START_COMMAND = '/start start'.freeze
  STOP_COMMAND = '/stop'.freeze

  def initialize
    @token = ENV['TELEGRAM_TOKEN']
  end

  def call
    Telegram::Bot::Client::run(token) do |bot|
      bot.listen do |message|
        user_info = message.from.to_h.slice(:id, :username, :first_name, :last_name, :language_code)

        if message.photo.any?
         SubmitAnswerJob.perform_async(from: user_info, photo: message.photo)
        else
          user = User.where(id: user_info[:id]).first
          case message.text
          when START_COMMAND, MAC_START_COMMAND
            responce = if user.nil?
                User.create(user_info)
                SUCCESS_MESSAGE
              elsif user.inactive?
                user.activate!
                ACTIVATED_MESSAGE
              else
                ALREADY_SUBSCRIBED_MESSAGE
              end
          when STOP_COMMAND
            responce = if user.nil?
              NOT_INVITED_MESSAGE
            else
              user.deactivate!
              DEACTIVATED_MESSAGE
            end
          else
            responce = NOT_SUPPORTED_MESSAGE
          end
          SendMessageJob.perform_async(chat: user_info[:id], text: responce)
        end
      end
    end
  end

  private
    attr_accessor :token
end
