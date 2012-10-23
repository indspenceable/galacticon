require './player'

class MenuSelector

  # hash of names of menus to menu
  MENUS = [
    [:select_ship,    Player::SHIPS],
    [:config_buttons, Player::BUTTONS],
    [:ready,          [true,false]]
  ]
  def current_menu_option
    current_menu_options[@current_menu_selections[@current_menu]]
  end
  def current_menu_options
    MENUS[@current_menu][1]
  end
  def current_menu
    MENUS[@current_menu][0]
  end

  def current_button
    menu = MENUS.find_index{|m| m[0] == :config_buttons}
    MENUS[menu][1][@current_menu_selections[menu]]
  end
  def ship_klass
    menu = MENUS.find_index{|m| m[0] == :select_ship}
    MENUS[menu][1][@current_menu_selections[menu]]
  end
  def ready?
    menu = MENUS.find_index{|m| m[0] == :ready}
    MENUS[menu][1][@current_menu_selections[menu]]
  end

  attr_reader :player
  def initialize player
    @player = player

    @current_menu = 0
    @current_menu_selections = Array.new(MENUS.length) { 0 }
    @current_menu_selections[2] += 1 if team == 0
    @current_menu_selections[0] = Player::SHIPS.index(@player.ship_klass)
  end

  def team
    @player.team
  end
  def color
    @player.color
  end

  def pressed_button id
    if current_menu == :config_buttons
      @player.bind_action_to_button current_menu_option, id
    end
  end

  def up!
    @current_menu_selections[@current_menu] = (@current_menu_selections[@current_menu] +current_menu_options.length - 1)% (current_menu_options.length)
  end
  def down!
    @current_menu_selections[@current_menu] = (@current_menu_selections[@current_menu] + current_menu_options.length + 1)% (current_menu_options.length)
  end
  def left!
    @current_menu = (@current_menu + MENUS.length - 1)% (MENUS.length)
  end
  def right!
    @current_menu = (@current_menu + MENUS.length + 1)% (MENUS.length)
  end
end
