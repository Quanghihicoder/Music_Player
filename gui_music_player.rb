require 'rubygems'
require 'gosu'
require './input_functions.rb'
require './album_functions.rb'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class ArtWork
	attr_accessor :bmp

	def initialize (file)
		@bmp = Gosu::Image.new(file)
	end
end

class MusicPlayerMain < Gosu::Window

	def initialize
	  super(600,800,false)
	  self.caption = "Music Player by Quanghihi"
		@background = BOTTOM_COLOR
		@player = TOP_COLOR
		@track_font = Gosu::Font.new(15)
    music_file = File.new("album.txt", "r")
		@albums = read_albums(music_file)
    @album_id = $select
    @album = @albums[@album_id]
    @track_id = 0 
    @location = @album.tracks[@track_id].location.chomp
    @song = Gosu::Song.new(@location)
    @song.play(false) 
    @song.volume = 0.5
    @turn_off = false
	
	end

  def auto_play()
    if Gosu::Song.current_song == nil
      if @track_id < @album.tracks.length-1
        @track_id += 1
        @location = @album.tracks[@track_id].location.chomp
        @song = Gosu::Song.new(@location)
        @song.play(false)
      else
        if @album_id < @albums.length-1
          @album_id += 1
        else
          @album_id = 0
        end
        @track_id = 0
        @album = @albums[@album_id]
        @location = @album.tracks[@track_id].location.chomp
        @song = Gosu::Song.new(@location)
        @song.play(false)
      end
    end
  end
  # Draws the artwork on the screen for all the albums

  def draw_albums()
    # complete this code
	  @album_image = ArtWork.new("images/2019-2020_world_tour.bmp")
    case @album_id
    when 0
      @album_image = ArtWork.new("images/2019-2020_world_tour.bmp")
    when 1
      @album_image = ArtWork.new("images/Lilac.bmp")
    when 2
      @album_image = ArtWork.new("images/Made.bmp")
    when 3
      @album_image = ArtWork.new("images/Stories.bmp")
    end
    @album_image.bmp.draw(150,50,2)
  end

  def draw_displaytrack()
    @display_track_image = ArtWork.new("images/displaytrack.bmp")
    @display_track_image.bmp.draw(143, 404, 2)
  end
  
  def draw_track_and_album_name()
    @album_name = "Album:  " + @albums[@album_id].title.chomp + " by " + @albums[@album_id].artist.chomp
    @track_font.draw_text(@album_name, 177, 413, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
    @i = 0 
    @stay_string = @track_id #to make sure not to change string when click at blank in button_down(id)
    while @i <= @album.tracks.length
      if @i == 0 
        @name = @album.tracks[@i].name.chomp rescue ""
        if @i == @track_id and @name != ""
          @name = @album.tracks[@track_id].name.upcase + "  =>  Now playing"
        end
        @track_font.draw_text(@name, 154, 437, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
      elsif @i == 1 
        @name = @album.tracks[@i].name.chomp rescue ""
        if @i == @track_id and @name != ""
          @name = @album.tracks[@track_id].name.upcase + "  =>  Now playing"
        end
        @track_font.draw_text(@name, 154, 467, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
      elsif @i == 2 
        @name = @album.tracks[@i].name.chomp rescue ""
        if @i == @track_id and @name != ""
          @name = @album.tracks[@track_id].name.upcase + "  =>  Now playing"
        end
        @track_font.draw_text(@name, 154, 497, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
      elsif @i == 3 
        @name = @album.tracks[@i].name.chomp rescue ""
        if @i == @track_id and @name != ""
          @name = @album.tracks[@track_id].name.upcase + "  =>  Now playing"
        end
        @track_font.draw_text(@name, 154, 527, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
      elsif @i == 4 
        @name = @album.tracks[@i].name.chomp rescue ""
        if @i == @track_id and @name != ""
          @name = @album.tracks[@track_id].name.upcase + "  =>  Now playing"
        end
        @track_font.draw_text(@name, 154, 557, ZOrder::UI, 1.0, 1.0, Gosu::Color::BLACK)
      end
    @i += 1
    end
  end

  def random_a_song
    old_album_id = @album_id
    old_track_id = @track_id
    
    @album_id = rand(0..3)
    @album = @albums[@album_id]
    @track_id = rand(0..@album.tracks.length-1)
    while old_album_id == @album_id && old_track_id == @track_id
      @album_id = rand(3)
      @album = @albums[@album_id]
      @track_id = rand(0..@album.tracks.length-1)
    end
    
    @location = @album.tracks[@track_id].location.chomp
    @song = Gosu::Song.new(@location)
    @song.play(false) 
    @song.volume = 0.5
    @turn_off = false

  end

  def draw_buttons()
    @music_buttons = ArtWork.new("images/button.bmp")
    @music_buttons.bmp.draw(70,600,3)
    @track_font.draw_text("<< Back to Home ", 10, 10, ZOrder::UI, 1.5, 1.5, Gosu::Color::WHITE)
    @track_font.draw_text("Random a song ", 200, 700, ZOrder::UI, 2.0, 2.0, Gosu::Color::WHITE)
    Gosu.draw_rect(200, 730, 190, 5, Gosu::Color::WHITE , ZOrder::UI, mode=:default)
  end
 
 
  def area_clicked(mouse_x,mouse_y)
     # complete this code
    if (mouse_y < 675 && mouse_y> 609) then
      if (mouse_x < 160 && mouse_x > 95) then
         return 1
      elsif (mouse_x < 245 && mouse_x > 178) then
         return 2
      elsif (mouse_x < 325 && mouse_x > 260) then
         return 3
      elsif (mouse_x < 408 && mouse_x > 343) then
         return 4
      elsif (mouse_x < 493 && mouse_x > 429) then
         return 5
      end
    end
    
    if (mouse_x < 442 && mouse_x > 145) then
      if (mouse_y < 461  && mouse_y > 434) then
         return 6
      elsif (mouse_y < 492 && mouse_y > 461) then
         return 7
      elsif (mouse_y < 520 && mouse_y > 492) then
         return 8
      elsif (mouse_y < 547 && mouse_y > 520) then
         return 9
      elsif (mouse_y < 574 && mouse_y > 547) then
         return 10
      end
    end

    if (mouse_x < 164 && mouse_x > 10)
      if (mouse_y < 26  && mouse_y > 12)
        return 11
      end
    end

    if (mouse_x < 388 && mouse_x > 202)
      if (mouse_y < 732  && mouse_y > 706)
        return 12
      end
    end

  end



	def draw_background()
		Gosu.draw_rect(0, 0, 600, 800, @background, ZOrder::BACKGROUND, mode=:default)
    Gosu.draw_rect(40, 40, 510, 710, @player, ZOrder::PLAYER, mode=:default)
    draw_albums()
    draw_displaytrack()
    draw_track_and_album_name()
    draw_buttons()
    # puts ("#{mouse_x} ; #{mouse_y}")
	end
 

  def update
    if @turn_off == false
      auto_play()
    end
  end


	def draw()
		# Complete the missing code
		draw_background()
	end

 	def needs_cursor?; true; end

	def button_down(id)
    case id
    when Gosu::KbS
      @song.stop
      @turn_off = true 
    when Gosu::KbP
      @song.play
      @turn_off = false
    when Gosu::KbDown
      if @song.volume > 0.05 then
        @song.volume -= 0.1
      end
    when Gosu::KbUp
      if @song.volume < 0.95 then 
        @song.volume += 0.1
      end
    when Gosu::KbRight
      if @track_id < @album.tracks.length-1
        @track_id += 1
        @location = @album.tracks[@track_id].location.chomp
        @song = Gosu::Song.new(@location)
        @song.play(false)
      else
        if @album_id < @albums.length-1
          @album_id += 1
        else
          @album_id = 0
        end
        @track_id = 0
        @album = @albums[@album_id]
        @location = @album.tracks[@track_id].location.chomp
        @song = Gosu::Song.new(@location)
        @song.play(false)
      end
      @turn_off = false
    when Gosu::KbLeft
      if @track_id > 0 
        @track_id -= 1
        @location = @album.tracks[@track_id].location.chomp
        @song = Gosu::Song.new(@location)
        @song.play(false)
      else
        if @album_id > 0
          @album_id -= 1
        else
          @album_id = @albums.length-1
        end
        @album = @albums[@album_id]
        @track_id = @album.tracks.length-1
        @location = @album.tracks[@track_id].location.chomp
        @song = Gosu::Song.new(@location)
        @song.play(false)
      end
      @turn_off = false
    #control by click  
    when Gosu::MsLeft
      button = area_clicked(mouse_x,mouse_y)
      case button
      when 1
        @song.play(true)
        @turn_off = false
      when 2
        @song.pause
      when 3
        @song.stop
        @turn_off = true 
      when 4
        if @track_id > 0 
          @track_id -= 1
          @location = @album.tracks[@track_id].location.chomp
          @song = Gosu::Song.new(@location)
          @song.play(false)
        else
          if @album_id > 0
            @album_id -= 1
          else
            @album_id = 3
          end
          @album = @albums[@album_id]
          @track_id = @album.tracks.length-1
          @location = @album.tracks[@track_id].location.chomp
          @song = Gosu::Song.new(@location)
          @song.play(false)
        end
        @turn_off = false
      when 5
        if @track_id < @album.tracks.length-1
          @track_id += 1
          @location = @album.tracks[@track_id].location.chomp
          @song = Gosu::Song.new(@location)
          @song.play(false)
        else
          if @album_id < @albums.length-1
            @album_id += 1
          else
            @album_id = 0
          end
          @track_id = 0
          @album = @albums[@album_id]
          @location = @album.tracks[@track_id].location.chomp
          @song = Gosu::Song.new(@location)
          @song.play(false)
        end
        @turn_off = false
      when 6
        @track_id = 0 
        if @track_id > @album.tracks.length-1 
          @track_id = @stay_string
        else
          @location = @album.tracks[@track_id].location.chomp
          @song = Gosu::Song.new(@location)
          @song.play(false) 
        end 
        @turn_off = false
      when 7
        @track_id = 1 
        if @track_id > @album.tracks.length-1 
          @track_id = @stay_string
        else
          @location = @album.tracks[@track_id].location.chomp
          @song = Gosu::Song.new(@location)
          @song.play(false) 
        end 
        @turn_off = false
      when 8
        @track_id = 2 
        if @track_id > @album.tracks.length-1 
          @track_id = @stay_string
        else
          @location = @album.tracks[@track_id].location.chomp
          @song = Gosu::Song.new(@location)
          @song.play(false) 
        end 
        @turn_off = false
      when 9
        @track_id = 3 
        if @track_id > @album.tracks.length-1 
          @track_id = @stay_string
        else
          @location = @album.tracks[@track_id].location.chomp
          @song = Gosu::Song.new(@location)
          @song.play(false) 
        end
        @turn_off = false
      when 10
        @track_id = 4 
        if @track_id > @album.tracks.length-1 
          @track_id = @stay_string
        else
          @location = @album.tracks[@track_id].location.chomp
          @song = Gosu::Song.new(@location)
          @song.play(false) 
        end
        @turn_off = false 
      when 11
        close
        @song.stop
        @turn_off = true
        Home.new.show if __FILE__ == $0
      when 12
        random_a_song()
      end
    end
  end 
end

# Show is a method that loops through update and draw

# MusicPlayerMain.new.show if __FILE__ == $0


class Home < Gosu::Window
  def initialize
    super(600,800,false)
    self.caption = "Music Player"
    @background = BOTTOM_COLOR
    @player = TOP_COLOR
    @track_font = Gosu::Font.new(15)
    music_file = File.new("album.txt", "r")
		@album = read_albums(music_file)
  end


  def draw_albums
    # complete this code
	  @album_image = ArtWork.new("images/2019-2020_world_tour.bmp")
	  @album_image.bmp.draw(60,191,2,0.7,0.7)
    @album_image = ArtWork.new("images/Lilac.bmp")
    @album_image.bmp.draw(330,191,2,0.7,0.7)
    @album_image = ArtWork.new("images/Made.bmp")
	  @album_image.bmp.draw(60,477,2,0.7,0.7)
    @album_image = ArtWork.new("images/Stories.bmp")
    @album_image.bmp.draw(330,477,2,0.7,0.6)
  end

  def draw_button()
    @track_font.draw_text("All Albums", 220, 100, ZOrder::UI, 2.5, 2.5, Gosu::Color::BLUE)
    Gosu.draw_rect(220, 134, 160, 5, Gosu::Color::BLUE , ZOrder::UI, mode=:default)

  end

  def draw_album_name()
    @name = @album[0].title
    @track_font.draw_text(@name, 60, 400, ZOrder::UI, 1.5, 1.5, Gosu::Color::WHITE)
    @name = @album[1].title
    @track_font.draw_text(@name, 400, 400, ZOrder::UI, 1.5, 1.5, Gosu::Color::WHITE) 
    @name = @album[2].title
    @track_font.draw_text(@name, 130, 690, ZOrder::UI, 1.5, 1.5, Gosu::Color::WHITE) 
    @name = @album[3].title
    @track_font.draw_text(@name, 400, 690, ZOrder::UI, 1.5, 1.5, Gosu::Color::WHITE)  
  end

  def area_clicked(mouse_x,mouse_y)
    if (mouse_y < 388 && mouse_y> 190) 
      if (mouse_x < 260 && mouse_x > 59) 
        return 0
      elsif (mouse_x < 529 && mouse_x > 331) 
        return 1
      end
    elsif (mouse_y < 676 && mouse_y > 477) 
      if (mouse_x < 260 && mouse_x > 59) 
        return 2
      elsif (mouse_x < 529 && mouse_x > 331)
        return 3
      end
    end

  end
  
  def draw_background()
    Gosu.draw_rect(0, 0, 600, 800, @background, ZOrder::BACKGROUND, mode=:default)
    Gosu.draw_rect(40, 40, 510, 710, @player, ZOrder::PLAYER, mode=:default)
    draw_albums()
    draw_album_name()
    draw_button()
    # puts ("#{mouse_x} ; #{mouse_y}")
    
  end

  def draw()
		# Complete the missing code
		draw_background()
	end

 	def needs_cursor?; true; end


  def button_down(id)
    case id
    when Gosu::MsLeft
      button = area_clicked(mouse_x,mouse_y)
      case button
      when 0
        $select = 0
        close
        MusicPlayerMain.new.show if __FILE__ == $0
      when 1
        $select = 1
        close
        MusicPlayerMain.new.show if __FILE__ == $0
      when 2
        $select = 2
        close
        MusicPlayerMain.new.show if __FILE__ == $0
      when 3
        $select = 3
        close
        MusicPlayerMain.new.show if __FILE__ == $0
      end
    end
  end

end

Home.new.show

