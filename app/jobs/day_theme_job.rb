class DayThemeJob
  include SuckerPunch::Job

  def perform(params)
    SendCurrentTheme.call
  end
end
