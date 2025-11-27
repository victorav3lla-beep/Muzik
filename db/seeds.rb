puts "🧹 Cleaning database..."
PlaylistTrack.destroy_all
Track.destroy_all
Playlist.destroy_all
Chat.destroy_all

puts "🎵 Creating tracks..."
# Create some classic tracks
bohemian_rhapsody = Track.create!(
  title: "Bohemian Rhapsody",
  artist: "Queen",
  url: "https://open.spotify.com/track/4u7EnebtmKWzUH433cf5Qv",
  duration: 354
)

stairway_to_heaven = Track.create!(
  title: "Stairway to Heaven",
  artist: "Led Zeppelin",
  url: "https://open.spotify.com/track/5CQ30WqJwcep0pYcV4AMNc",
  duration: 482
)

sweet_child = Track.create!(
  title: "Sweet Child O' Mine",
  artist: "Guns N' Roses",
  url: "https://open.spotify.com/track/7o2CTH4ctstm8TNelqjb51",
  duration: 356
)

billie_jean = Track.create!(
  title: "Billie Jean",
  artist: "Michael Jackson",
  url: "https://open.spotify.com/track/5ChkMS8OtdzJeqyybCc9R5",
  duration: 294
)

smells_like = Track.create!(
  title: "Smells Like Teen Spirit",
  artist: "Nirvana",
  url: "https://open.spotify.com/track/4CeeEOM32jQcH3eN9Q2dGj",
  duration: 301
)

puts "👤 Creating test user..."
# Make sure we have a user (adjust based on your User model)
user = User.first || User.create!(
  email: "test@lewagon.com",
  password: "123456"
)

puts "📝 Creating playlists..."
# Playlist 1: Classic Rock
classic_rock = Playlist.create!(
  title: "Classic Rock Anthems",
  content: "The best rock songs that defined a generation",
  user: user
)

PlaylistTrack.create!(playlist: classic_rock, track: bohemian_rhapsody)
PlaylistTrack.create!(playlist: classic_rock, track: stairway_to_heaven)
PlaylistTrack.create!(playlist: classic_rock, track: sweet_child)

# Playlist 2: 90s Hits
nineties_hits = Playlist.create!(
  title: "90s Greatest Hits",
  content: "Nostalgic tracks from the 90s",
  user: user
)

PlaylistTrack.create!(playlist: nineties_hits, track: smells_like)
PlaylistTrack.create!(playlist: nineties_hits, track: billie_jean)

puts "✅ Created #{User.count} user, #{Playlist.count} playlists, #{Track.count} tracks, #{PlaylistTrack.count} playlist-track associations"
puts "🎉 Seeding finished!"
