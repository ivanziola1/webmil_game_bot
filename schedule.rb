scheduler = Rufus::Scheduler.new

scheduler.every '15s' do # .cron '0 8 * * *' do
  DayThemeJob.perform_async('Hello')
end
# scheduler.join
