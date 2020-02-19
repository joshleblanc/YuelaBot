class LaunchManager
  include Discordrb::Webhooks
  include Singleton
  def initialize
    @jobs = []
  end

  def launches
    @launches ||= fetch_launches
  end

  def schedule
    unschedule_all
    fetch_launches
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
    embed.title = launch['name']
    if launch['vidUrls']
      embed.url = launch['vidUrls'].first
    else
      embed.url = launch['vidUrl']
    end

    configs = LaunchAlertConfig.all

    configs.each do |config|
      mentions = config.users.map { |u| "<@#{u.id}>"}
      p mentions, embed
      BOT.send_message(config.channel_id, mentions, false, embed)
    end
  end

  def unschedule_all
    @jobs.each do |job_id|
      job = Rufus::Scheduler.s.job(job_id)
      if job
        job.unschedule
        job.kill
      end
    end
  end

  def fetch_launches
    response = RestClient.get("https://launchlibrary.net/1.4/launch")
    JSON.parse(response.body)["launches"]
  end
end
