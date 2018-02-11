require_relative 'application_service'

class TodayTheme < ApplicationService
  THEMES = [
    'Dog',
    'People',
    'Books',
    'Flower',
    'Food',
    'City',
    'Nature',
    'Car',
    'Building',
    'Bridge'
  ].freeze

  def call
    recent_themes = DateTheme.order(Sequel.desc(:date)).limit(3).map(:theme)
    loop do
      theme = THEMES.sample
      break theme unless recent_themes.include?(theme)
    end
  end
end
