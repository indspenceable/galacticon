require 'gosu'

#classes
require './ships/standard_ship'
require './ships/quick_ship'
require './ships/arilou'

class Player
  MENU_ITEMS = [
    :accelerate,
    :primary,
    :secondary,
    :tertiary
  ]
  attr_reader :team, :ship_klass
  def initialize team
    @team = team
    @current_menu_index = 0
    # default bindings
    @bindings = {
      :left => Gosu::const_get(:"Gp#{team}Left"),
      :right => Gosu::const_get(:"Gp#{team}Right"),
      :accelerate => Gosu::const_get(:"Gp#{team}Button1"),
      :primary => Gosu::const_get(:"Gp#{team}Button0"),
      :secondary => Gosu::const_get(:"Gp#{team}Button2"),
      :tertiary => Gosu::const_get(:"Gp#{team}Button3")
    }
  end
  def bind_current_menu_item_to button
    @bindings[MENU_ITEMS[@current_menu_index]] = button
  end
  def key_binding(action)
    @bindings[action]
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

    setup_ships!

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
      if button_down? s.player.key_binding(:left)
        s.turn_left
      end
      if button_down? s.player.key_binding(:right)
        s.turn_right
      end
      if button_down? s.player.key_binding(:accelerate)
        s.accelerate
      end
      if button_down? s.player.key_binding(:primary)
        s.primary.attempt_activate!(self)
      end
      if button_down? s.player.key_binding(:secondary)
        s.secondary.attempt_activate!(self)
      end
      if button_down? s.player.key_binding(:tertiary)
        s.tertiary.attempt_activate!(self)
      end
      s.tick
    end
  end

  def in_game?
    true
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
      @between_games = true
    end

    @shots.each(&:move)
    @shots.each do |s|
      s.check_for_collisions!(@ships)
    end
    @shots.reject!(&:expired?)
  end
  def update_between_games

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
      #loop through each button they might press
      15.times do |i|
        if id == Gosu::const_get(:"Gp#{p.team}Button#{i}")
          p.bind_current_menu_item_to(id)
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
