require './modes/menu_selector'
require './modes/battle'
#ready?
#current_menu
#ship_klass
#team
#bind_current_action_to_id

# up! down! left! right!

class MenuMode
  attr_reader :selectors
  def initialize window, players
    @players = players
    @selectors = players.map{|p| MenuSelector.new(p) }
    @window = window
  end

  # lifted from window
  def update
    if selectors.select{ |p| !p.ready? }.empty?
      selectors.each do |s|
        s.player.ship_klass = s.ship_klass
      end
      Battle.new(@window, @players)
    end
  end

  def draw
    selectors.each do |selector|
      y = 150*selector.team + 30
      effect_id = 16*(10+selector.team)

      x = 25
      @window.effects[effect_id].draw(x, y-20, 1) if selector.current_menu == :select_ship
      @window.ship_images[selector.ship_klass.image_offset].draw(x, y, 1) if selector.ship_klass

      x = 200
      @window.font.draw("Player #{selector.team} (#{selector.player.points})", x, y, 1, 1, 1)

      x = 350
      @window.effects[effect_id].draw(x, y-20, 1) if selector.current_menu == :config_buttons
      @window.font.draw("Config Buttons #{selector.current_button}", x, y, 1, 1, 1)

      x = 600
      @window.effects[effect_id].draw(x, y-20, 1) if selector.current_menu == :ready
      @window.font.draw("Start#{selector.ready? ? '!' : '?'}", x, y, 1, 1, 1)
    end
  end

 def button_down(id)
    selectors.each do |p|
        if id == Gosu::const_get(:"Gp#{p.team}Up")
          p.up!
        elsif id == Gosu::const_get(:"Gp#{p.team}Left")
          p.left!
        elsif id == Gosu::const_get(:"Gp#{p.team}Right")
          p.right!
          puts p.current_menu
        elsif id == Gosu::const_get(:"Gp#{p.team}Down")
          p.down!
        end
      #loop through each button they might press
      15.times do |i|
        if id == Gosu::const_get(:"Gp#{p.team}Button#{i}")
          p.pressed_button(id)
        end
      end
    end
  end
end
