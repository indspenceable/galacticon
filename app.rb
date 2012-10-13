require 'gosu'

#classes
require './standard_ship'
require './quick_ship'
require './arilou'

class GameWindow < Gosu::Window
  def initialize
    super(1280, 960, false)
    self.caption = "Gosu Tutorial Game"

    #@background_image = Gosu::Image.new(self, "media/Space.png", true)

    @player = StandardShip.new(self)
    @player.warp(320, 240)
  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft
      @player.turn_left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight
      @player.turn_right
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton1
      @player.accelerate
    end
    @player.move

    @shots.each(&:move)
    @shots.reject!(&:expired?)
  end

  def draw
    @player.draw
    @shots.each(&:draw)
    #@background_image.draw(0, 0, 0);
  end

  #TODO can we factor this out to the ships?
  def button_down(id)
    case id
    when Gosu::KbEscape
      close
    when Gosu::GpButton0
      @player.action1(self)
    when Gosu::GpButton2
      @player.action2(self)
    when Gosu::GpButton3
      @player.action2(self)
    end
  end

  # utility functions
  def ship_images
    @ship_images ||= Gosu::Image.load_tiles(self, "ships.png", 26, 18, false)
  end
  def effects
    @effects ||= Gosu::Image.load_tiles(self, "effects.png", 24, 24, false)
  end
  def shots
    @shots ||= []
  end


end

window = GameWindow.new
window.show
