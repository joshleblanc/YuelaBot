class FetchTraitsJob < ApplicationJob
  def perform(type)
    Rails.cache.fetch("venice_model_traits/#{type}", expires_in: 1.hour) do 
      traits_api = VeniceClient::ModelsApi.new

      traits_api.list_model_traits(type: type).data
    end
  end
end