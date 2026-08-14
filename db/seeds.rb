# db/seeds.rb
#
# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require "open-uri"
require "json"

# Original 4 seeded movies
Movie.create(title: "Wonder Woman 1984", overview: "Wonder Woman comes into conflict with the Soviet Union during the Cold War in the 1980s", poster_url: "https://image.tmdb.org/t/p/original/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg", rating: 6.9)
Movie.create(title: "The Shawshank Redemption", overview: "Framed in the 1940s for double murder, upstanding banker Andy Dufresne begins a new life at the Shawshank prison", poster_url: "https://image.tmdb.org/t/p/original/q6y0Go1tsGEsmtFryDOJo3dEmqu.jpg", rating: 8.7)
Movie.create(title: "Titanic", overview: "101-year-old Rose DeWitt Bukater tells the story of her life aboard the Titanic.", poster_url: "https://image.tmdb.org/t/p/original/9xjZS2rlVxm8SFx8kPC3aIGCOYQ.jpg", rating: 7.9)
Movie.create(title: "Ocean's Eight", overview: "Debbie Ocean, a criminal mastermind, gathers a crew of female thieves to pull off the heist of the century.", poster_url: "https://image.tmdb.org/t/p/original/MvYpKlpFukTivnlBhizGbkAe3v.jpg", rating: 7.0)

# API-seeded movies (multiple pages, for a bigger library)
(1..5).each do |page|
  url = "https://tmdb.lewagon.com/movie/top_rated?page=#{page}"
  response = URI.open(url).read
  data = JSON.parse(response)

  data["results"].each do |movie_data|
    next if movie_data["poster_path"].nil?

    Movie.find_or_create_by(title: movie_data["title"]) do |movie|
      movie.overview = movie_data["overview"]
      movie.poster_url = "https://image.tmdb.org/t/p/original" + movie_data["poster_path"]
      movie.rating = movie_data["vote_average"]
    end
  end
end

# Lists with photos
unless List.exists?(name: "Comedy")
  list = List.create!(name: "Comedy")
  photo = URI.parse("https://dnm.nflximg.net/api/v6/2DuQlx0fM4wd1nzqm5BFBi6ILa8/AAAAQaUiPLJpaxXAL-CGwnV-UUKic7arMB-yY4SY7enUbFgSksNG0BClmStlVX4vJO7EIkOODAr7zgP5aO0sPt3iG3XKNVEfbyLY-xQ4bMpzVHHRkSziQ5MnueXkDn4VXT2RfN7C4QEgg-2OvnrRVTfNluW7.jpg?r=936").open
  list.photo.attach(io: photo, filename: "photo.png", content_type: "image/png")
end

unless List.exists?(name: "Action")
  list = List.create!(name: "Action")
  photo = URI.parse("https://deadline.com/wp-content/uploads/2025/05/Rambo-First-Blood.webp?w=681&h=383&crop=1").open
  list.photo.attach(io: photo, filename: "photo.png", content_type: "image/png")
end
