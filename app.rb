require 'gosu'

#classes
require './ships/standard_ship'
require './ships/quick_ship'
require './ships/arilou'

class GameWindow < Gosu::Window
  WIDTH = (Gosu.screen_width * 0.9).round
  HEIGHT = (Gosu.screen_height * 0.8).round

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Gosu Tutorial Game"

    #@background_image = Gosu::Image.new(self, "media/Space.png", true)
    ships = [StandardShip,QuickShip,Arilou]

    @players = []
    @players << ships.sample.new(self, 0)
    @players[0].warp(320, 240)
    @players << ships.sample.new(self, 1)
    @players[1].warp(640, 480)
    @players << ships.sample.new(self, 2)
    @players[2].warp(780, 240)
  end

  def process_button_presses_for_players!
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
  end

  def update
    process_button_presses_for_players!
    @players.reject!(&:expired?)

    @shots.each(&:move)
    @shots.each do |s|
      s.check_for_collisions!(@players)
    end
    @shots.reject!(&:expired?)
  end

  def draw_player p
    width  = p.hull
    height = 30

    x, y, color = case p.team
      when 0
        [0,0, Gosu::Color::RED]
      when 1
        [WIDTH - Ship::MAX_HULL, 0, Gosu::Color::GREEN]
      when 2
        [0, HEIGHT - height, Gosu::Color::BLUE]
      when 3
        [WIDTH - Ship::MAX_HULL, HEIGHT - height, Gosu::Color::FUCHSIA]
    end

    #puts color.inspect, Gosu::Color::RED

    draw_quad(
              x,          y, color,
      x + width,          y, color,
              x, y + height, color,
      x + width, y + height, color
    )
  end

  def draw
    @players.each(&:draw)
    @players.each { |p| draw_player p }
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
        p.action3(self)
      end
    end
  end

  # utility functions
  def ship_images
    @ship_images ||= Gosu::Image.load_tiles(self, "ships.png", 26*2, 18*2, false)
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
