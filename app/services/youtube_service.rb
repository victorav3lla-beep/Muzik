require 'net/http'
require 'json'

class YoutubeSearchService
  def self.search(query)
    api_key = ENV['YOUTUBE_API_KEY']
    encoded_query = URI.encode_www_form_component(query)
    url = "https://www.googleapis.com/youtube/v3/search?part=snippet&q=#{encoded_query}&type=video&maxResults=1&key=#{api_key}"

    response = Net::HTTP.get(URI(url))
    data = JSON.parse(response)

    if data['items'] && data['items'].any?
      video_id = data['items'].first['id']['videoId']
      "https://www.youtube.com/watch?v=#{video_id}"
    else
      nil
    end
  end
end
