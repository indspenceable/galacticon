require 'gosu'

#classes
require './ships/standard_ship'
require './ships/quick_ship'
require './ships/arilou'
require './ships/agile_ship'


class Player
  BUTTONS = [
    :accelerate,
    :primary,
    :secondary,
    :tertiary
  ]
  COLORS = [
    Gosu::Color::RED,
    Gosu::Color::GREEN,
    Gosu::Color::BLUE,
    Gosu::Color::FUCHSIA
  ]
  SHIPS = [
    nil,
    Arilou,
    StandardShip,
    QuickShip,
    AgileShip
  ]

  def color
    COLORS[team]
  end

  attr_reader :team
  def initialize team
    @team = team
    @current_button = 0
    @current_ship = 0
    # default bindings
    @bindings = {
      :left => Gosu::const_get(:"Gp#{team}Left"),
      :right => Gosu::const_get(:"Gp#{team}Right"),
      :accelerate => Gosu::const_get(:"Gp#{team}Button1"),
      :primary => Gosu::const_get(:"Gp#{team}Button0"),
      :secondary => Gosu::const_get(:"Gp#{team}Button2"),
      :tertiary => Gosu::const_get(:"Gp#{team}Button3")
    }
    @current_menu = 0
    @ready = (team != 0)

  end
  def ship_klass
    SHIPS[@current_ship]
  end
  def ready?
    @ready
  end
  def unready!
    @ready = false
  end
  def bind_current_action_to button
    @bindings[current_button] = button
  end
  def key_binding(action)
    @bindings[action]
  end


  def current_menu
    MENUS[@current_menu]
  end
  MENUS = [:start, :select_ship, :config_buttons]
  def config_buttons?
    current_menu == :config_buttons
  end
  def select_ship?
    current_menu == :select_ship
  end

  def current_button
    BUTTONS[@current_button]
  end

  def left!
    @current_menu -= 1
    @current_menu = MENUS.length-1 if @current_menu < 0
  end
  def right!
    @current_menu += 1
    @current_menu = 0 if @current_menu == MENUS.length
  end
  def down!
    if select_ship?
      @current_ship = (@current_ship + 1)%SHIPS.length
    elsif config_buttons?
      @current_button = (@current_button + 1)%BUTTONS.length
    else
      @ready = !@ready
    end
  end
  def up!
    if select_ship?
      @current_ship = (@current_ship - 1 + SHIPS.length)%SHIPS.length
    elsif config_buttons?
      @current_button = (@current_button - 1 + BUTTONS.length)%BUTTONS.length
    else
      @ready = !@ready
    end
  end

end

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
  end

  def setup_ships!
    @time_between_games = TIME_BETWEEN_GAMES
    @shots = []
    ships = [StandardShip,QuickShip,Arilou]

    @ships = []
    starting_locations = [
      [WIDTH/4 + WIDTH/4*0, HEIGHT/4 + HEIGHT/4*0],
      [WIDTH/4 + WIDTH/4*2, HEIGHT/4 + HEIGHT/4*0],
      [WIDTH/4 + WIDTH/4*0, HEIGHT/4 + HEIGHT/4*2],
      [WIDTH/4 + WIDTH/4*2, HEIGHT/4 + HEIGHT/4*2],
    ]
    @players.each do |p|
      klass = p.ship_klass || ships.sample
      ship = klass.new(self, p)
      ship.warp(*starting_locations[p.team])
      @ships << ship
    end

    @order_of_death = []
  end

  def process_button_presses_for_players!
    @ships.each do |s|
      s.turn_left                         if button_down? s.player.key_binding(:left)
      s.turn_right                        if button_down? s.player.key_binding(:right)
      s.accelerate                        if button_down? s.player.key_binding(:accelerate)
      s.primary.attempt_activate!(self)   if button_down? s.player.key_binding(:primary)
      s.secondary.attempt_activate!(self) if button_down? s.player.key_binding(:secondary)
      s.tertiary.attempt_activate!(self)  if button_down? s.player.key_binding(:tertiary)
      s.tick
    end
  end

  def in_game?
    !@between_games
  end

  #TODO this is obsolete
  def between_games!
    puts "Order of death is #{@order_of_death}" if @time_between_games == TIME_BETWEEN_GAMES
    @time_between_games -= 1
    setup_ships! if @time_between_games <= 0
  end

  def update_in_game
    process_button_presses_for_players!
    @ships.reject! do |p|
      if p.expired?
        @order_of_death << p.team
      end
    end
    if @ships.size <= 1
      @players.each do |p|
        p.unready!
      end
      @between_games = true
    end

    @shots.each(&:move)
    @shots.each do |s|
      s.check_for_collisions!(@ships)
    end
    @shots.reject!(&:expired?)
  end
  def update_between_games
    # DON"T NEED TO DO SHIT, PROBABALY.
    if @players.select{ |p| !p.ready? }.empty?
      setup_ships!
      @between_games = false
    end
  end

  def update
    in_game?? update_in_game : update_between_games
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

  def draw_in_game
    @ships.each(&:draw)
    @ships.each { |p| draw_player p }
    @shots.each(&:draw)
  end
  def draw_between_games
    @players.each do |p|
      y = 150*p.team + 30
      effect_id = 16*(10+p.team)

      x = 25
      effects[effect_id].draw(x, y-20, 1) if p.current_menu == :select_ship
      ship_images[p.ship_klass.image_offset].draw(x, y, 1) if p.ship_klass

      x = 100
      @font.draw("Player #{p.team}", x, y, 1, 1, 1)

      x = 200
      effects[effect_id].draw(x, y-20, 1) if p.current_menu == :config_buttons
      @font.draw("Config Buttons #{p.current_button}", x, y, 1, 1, 1)

      x = 500
      effects[effect_id].draw(x, y-20, 1) if p.current_menu == :start
      @font.draw("Start#{p.ready? ? '!' : '?'}", x, y, 1, 1, 1)
    end
  end
  def draw
    in_game?? draw_in_game : draw_between_games
  end

  #TODO can we factor this out to the ships?
  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
    button_down_between_games(id) unless in_game?
  end

  def button_down_between_games(id)
    @players.each do |p|
        if id == Gosu::const_get(:"Gp#{p.team}Up")
          p.up!
        elsif id == Gosu::const_get(:"Gp#{p.team}Left")
          p.left!
        elsif id == Gosu::const_get(:"Gp#{p.team}Right")
          p.right!
        elsif id == Gosu::const_get(:"Gp#{p.team}Down")
          p.down!
        end
      if p.config_buttons?
        #loop through each button they might press
        15.times do |i|
          if id == Gosu::const_get(:"Gp#{p.team}Button#{i}")
            p.bind_current_action_to(id)
          end
        end
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
