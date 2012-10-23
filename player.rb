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

  COLOR_SHUFFLE = {}
  teams = [0,1,2,3].shuffle
  4.times do |x|
    COLOR_SHUFFLE[x] = teams.pop
  end

  SHIPS = [
    nil,
    Arilou,
    StandardShip,
    QuickShip,
    AgileShip
  ]

  attr_reader :team, :points
  attr_accessor :ship_klass
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
    @ship_klass = nil
    @points = 0
  end

  def color
    #COLORS[COLOR_SHUFFLE[team]]
    COLOR_SHUFFLE[team]
  end
  def bind_action_to_button action, button
    @bindings[action] = button
  end
  def key_binding(action)
    @bindings[action]
  end
  def score! p
    @points += p
  end
end
