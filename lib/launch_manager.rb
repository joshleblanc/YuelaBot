class LaunchManager
  include Discordrb::Webhooks

  def initialize
    @jobs = []
  end

  def schedule
    unschedule_all
    launches.each do |launch|
      start = Time.parse(launch['windowstart']) - (30 * 60) # T-30
      jobs << Rufus::Scheduler.s.at(start) do
        embed = Embed.new
        embed.title = launch['name']
        embed.url = launch['vidUrls'].first || launch['vidUrl']

        configs = LaunchAlertConfig.all

        configs.each do |config|
          mentions = config.users.map { |u| "<@#{user.id}>"}
          BOT.send_message(config.channel_id, mentions, false, embed)
        end
      end
    end
  end

  private

  def unschedule_all
    jobs.each do |job|
      job.unschedule
      job.terminate
    end
  end

  def launches
    response = RestClient.get("https://launchlibrary.net/1.4/launch")
    JSON.parse(response.body)["launches"]
  end
end