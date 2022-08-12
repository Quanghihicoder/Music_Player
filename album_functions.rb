require './input_functions'
require 'gosu'
require 'rubygems'

# module Genre
#     POP, CLASSIC, JAZZ, ROCK = *1..4
# end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']
$album_file = nil

class Album
    attr_accessor :artist, :title, :genre, :tracks

    def initialize (artist, title, genre, tracks)
        @title = title
        @artist = artist
        @genre = genre
        @tracks = tracks
    end
end
  
class Track
    attr_accessor :name, :location
  
    def initialize (name, location)
        @name = name
        @location = location
    end

end

#=====================================================================================================
# 1.1 Read albums, album, tracks and track < 1 Menu Read Album File
def read_track music_file
	name = music_file.gets.chomp
    location = music_file.gets.chomp
    track = Track.new(name, location)
    return track
end

def read_tracks(music_file)
	tracks = Array.new()
	count = music_file.gets().to_i()
	index = 0
	while index < count
	  tracks << read_track(music_file)
	  index += 1
	end
	return tracks
end

def read_album music_file
		album_artist = music_file.gets
		album_title = music_file.gets
		album_genre = music_file.gets.to_i
	  	
        tracks = read_tracks(music_file) 
	 	
        album = Album.new(album_artist, album_title, album_genre, tracks)
           
	return album
end


def read_albums music_file
	albums = Array.new
	count = music_file.gets().to_i()
	index = 0
	while index < count
        albums << read_album(music_file)
	    index += 1
	end
	return albums
end



