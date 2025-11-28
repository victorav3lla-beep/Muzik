require 'net/http'
require 'json'

class YoutubeService
  def self.search(query)
    api_key = ENV['YOUTUBE_API_KEY']
    encoded_query = URI.encode_www_form_component(query)

    videoEmbeddable=true
    url = "https://www.googleapis.com/youtube/v3/search?part=snippet&type=video&videoEmbeddable=true&maxResults=1&q=#{encoded_query}&key=#{api_key}"
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
