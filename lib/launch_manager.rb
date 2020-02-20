class LaunchManager
  include Discordrb::Webhooks

  def initialize
    @jobs = []
  end

  def schedule
    unschedule_all
    launches.each do |launch|
      start = Time.parse(launch['windowstart']) - (30 * 60) # T-30
      @jobs << Rufus::Scheduler.s.at(start) do
        alert_users launch
      end
    end
  end

  private

  def alert_users(launch)
    embed = Embed.new
    embed.title = "Upcoming Launch!"
    embed.description = launch['name']
    if launch['vidUrls']
      embed.url = launch['vidUrls'].first
    else
      embed.url = launch['vidUrl']
    end

    configs = LaunchAlertConfig.all

    configs.each do |config|
      mentions = config.users.map { |u| "<@#{u.id}>"}
      BOT.send_message(config.channel_id, mentions, false, embed)
    end
  end

  def unschedule_all
    @jobs.each do |job|
      job.unschedule
      job.kill
    end
  end

  def launches
    response = RestClient.get("https://launchlibrary.net/1.4/launch")
    JSON.parse(response.body)["launches"]
  end
end