require 'gosu'

#classes

require './modes/menu_mode'
require './player'

class GameWindow < Gosu::Window
  WIDTH = (Gosu.screen_width * 0.9).round
  HEIGHT = (Gosu.screen_height * 0.8).round
  TIME_BETWEEN_GAMES = 1000
  attr_reader :shots

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Gosu Tutorial Game"
    @players = Array.new(4) {|x| Player.new(x) }

    @between_games = true

    @font = Gosu::Font.new(self, "Verdana", 24)
    @mode = MenuMode.new(self, @players)
  end

  def in_game?
    !@between_games
  end

  def update
    @mode = @mode.update || @mode
  end

  def draw
    @mode.draw
  end

  #TODO can we factor this out to the ships?
  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
    #button_down_between_games(id) unless in_game?
    @mode.button_down(id)
  end

  # TODO this should probably change.
  def ship_images
    @ship_images ||= Gosu::Image.load_tiles(self, "ships.png", 26*2, 18*2, false)
  end
  def effects
    @effects ||= Gosu::Image.load_tiles(self, "effects.png", 24, 24, false)
  end
  def font
    @font
  end
end

window = GameWindow.new
window.show
