require 'gosu'

#classes
require './standard_ship'
require './quick_ship'
require './arilou'

class GameWindow < Gosu::Window
  WIDTH = 1280
  HEIGHT = 960

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Gosu Tutorial Game"

    #@background_image = Gosu::Image.new(self, "media/Space.png", true)

    @players = []
    @players << StandardShip.new(self)
    @players[0].warp(320, 240)
    @players << Arilou.new(self)
    @players[1].warp(640, 480)
  end

  def update
    @players.each_with_index do |p,i|
      if button_down? Gosu::const_get(:"Gp#{i}Left")
        p.turn_left
      end
      if button_down? Gosu::const_get(:"Gp#{i}Right")
        p.turn_right
      end
      if button_down? Gosu::const_get(:"Gp#{i}Button1")
        p.accelerate
      end
      p.move
    end

    @shots.each(&:move)
    @shots.each do |s|
      s.check_for_collisions!(@players)
    end
    @shots.reject!(&:expired?)
  end

  def draw
    @players.each_with_index do |p, i|
      p.draw
      width  = p.hull
      height = 10

      x,y = case i
        when 0
          [0,0]
        when 1
          [WIDTH - Ship::MAX_HULL, 0]
        when 2
          [0, HEIGHT - height]
        when 3
          [WIDTH - Ship::MAX_HULL, HEIGHT - height]
      end

      draw_quad(
                x,          y, Gosu::Color::RED,
        x + width,          y, Gosu::Color::RED,
                x, y + height, Gosu::Color::RED,
        x + width, y + height, Gosu::Color::RED
      )
    end
    @shots.each(&:draw)
    #@background_image.draw(0, 0, 0);
  end

  #TODO can we factor this out to the ships?
  def button_down(id)
    if id == Gosu::KbEscape
      close
    end

    @players.each_with_index do |p,i|
      case id
      when Gosu::const_get(:"Gp#{i}Button0")
        p.action1(self)
      when Gosu::const_get(:"Gp#{i}Button2")
        p.action2(self)
      when Gosu::const_get(:"Gp#{i}Button3")
        p.action2(self)
      end
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
