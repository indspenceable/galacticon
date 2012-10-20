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

  attr_reader :team, :ship_klass
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
  end

  def bind_action_to_button action, button
    @bindings[action] = button
  end
  def key_binding(action)
    @bindings[action]
  end
end
