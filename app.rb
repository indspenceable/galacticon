require 'gosu'

#classes
require './ships/standard_ship'
require './ships/quick_ship'
require './ships/arilou'

class GameWindow < Gosu::Window
  WIDTH = (Gosu.screen_width * 0.9).round
  HEIGHT = (Gosu.screen_height * 0.8).round
  TIME_BETWEEN_GAMES = 1000
  attr_reader :shots

  def initialize
    super(WIDTH, HEIGHT, false)
    self.caption = "Gosu Tutorial Game"
    setup_ships!



    @font = Gosu::Font.new(self, "Verdana", 24)
  end

  def setup_ships!
    @time_between_games = TIME_BETWEEN_GAMES
    @shots = []
    ships = [StandardShip,QuickShip,Arilou]

    @players = []
    starting_locations = [
      [320, 240],
      [640, 240],
      [320, 480],
      [640, 480]
    ]
    4.times do |n|
      klass = ARGV[n] ? Kernel.const_get(ARGV[n].to_sym) : ships.sample
      ship = klass.new(self, n)
      ship.warp(*starting_locations[n])
      @players << ship
    end
    @order_of_death = []
  end

  def process_button_presses_for_players!
    @players.each do |p|
      if button_down? Gosu::const_get(:"Gp#{p.team}Left")
        p.turn_left
      end
      if button_down? Gosu::const_get(:"Gp#{p.team}Right")
        p.turn_right
      end
      if button_down? Gosu::const_get(:"Gp#{p.team}Button1")
        p.accelerate
      end
      p.move
    end
  end

  def between_games?
     @players.length <= 1
  end
  def between_games!
    puts "Order of death is #{@order_of_death}" if @time_between_games == TIME_BETWEEN_GAMES
    @time_between_games -= 1
    setup_ships! if @time_between_games <= 0
  end

  def update
    process_button_presses_for_players!
    @players.reject! do |p|
      if p.expired?
        @order_of_death << p.team
      end
    end
    between_games! if between_games?

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

    @font.draw_rel("Next game in: #{@time_between_games/100}...",WIDTH/2,HEIGHT/2,1,0.5,0.5) if between_games?
  end

  #TODO can we factor this out to the ships?
  def button_down(id)
    if id == Gosu::KbEscape
      close
    end

    @players.each_with_index do |p|
      case id
      when Gosu::const_get(:"Gp#{p.team}Button0")
        p.action1(self)
      when Gosu::const_get(:"Gp#{p.team}Button2")
        p.action2(self)
      when Gosu::const_get(:"Gp#{p.team}Button3")
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
end

window = GameWindow.new
window.show
