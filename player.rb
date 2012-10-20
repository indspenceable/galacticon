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
