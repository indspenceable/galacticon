class Battle
  attr_reader :shots
  def initialize window, players
    @window = window
    @players= players
    #TODO add countdown to start of game.

    #lifted from window
    @shots = []
    @ships = []

    starting_locations = [
      [window.width/4 + window.width/4*0, window.height/4 + window.height/4*0,  135],
      [window.width/4 + window.width/4*2, window.height/4 + window.height/4*0, -135],
      [window.width/4 + window.width/4*0, window.height/4 + window.height/4*2,   45],
      [window.width/4 + window.width/4*2, window.height/4 + window.height/4*2, - 45],
    ]
    @players.each do |p|
      klass = p.ship_klass || Player::SHIPS.compact.sample
      ship = klass.new(@window, self, p)
      ship.warp(*starting_locations[p.team])
      @ships << ship
    end

    @order_of_death = []
  end

  def update
    process_button_presses_for_players!
    @ships.reject! do |p|
      if p.expired?
        @order_of_death << p.player
      end
    end

    @shots.each(&:move)
    @shots.each do |s|
      collidables = @ships
      collidables += @shots.reject(&:ignore_hits?) if s.deals_damage?
      s.check_for_collisions!(collidables)
    end
    @shots.reject!(&:expired?)

    if @ships.size <= 1
      @order_of_death << @ships.first.player
      @order_of_death.each_with_index do |p, i|
        p.score!(i)
      end
      MenuMode.new(@window, @players)
    end
  end


  def draw
    @ships.each(&:draw)
    @ships.each { |p| draw_player p }
    @shots.each(&:draw)
  end

  def button_down id
  end

  private

  def process_button_presses_for_players!
    @ships.each do |s|
      s.turn_left                            if @window.button_down? s.player.key_binding(:left)
      s.turn_right                           if @window.button_down? s.player.key_binding(:right)
      s.accelerate                           if @window.button_down? s.player.key_binding(:accelerate)
      s.primary.attempt_activate!(@window)   if @window.button_down? s.player.key_binding(:primary)
      s.secondary.attempt_activate!(@window) if @window.button_down? s.player.key_binding(:secondary)
      s.tertiary.attempt_activate!(@window)  if @window.button_down? s.player.key_binding(:tertiary)
      s.tick
    end
  end

  def draw_player p
    total  = 100.0
    health_bar_width = p.hull * (total/p.max_hull)
    battery_width = p.battery * (total/p.max_battery)
    health_bar_height = 15
    battery_height = 30
    height = battery_height

    x, y, color = case p.team
      when 0
        [0,0, Gosu::Color::RED]
      when 1
        [@window.width - total, 0, Gosu::Color::GREEN]
      when 2
        [0, @window.height - height, Gosu::Color::BLUE]
      when 3
        [@window.width - total,  @window.height - height, Gosu::Color::FUCHSIA]
    end

    @window.draw_quad(
                         x,                     y, color,
      x + health_bar_width,                     y, color,
                         x, y + health_bar_height, color,
      x + health_bar_width, y + health_bar_height, color
    )
    @window.draw_quad(
                      x,    y + battery_height, color,
      x + battery_width,    y + battery_height, color,
                      x, y + health_bar_height, color,
      x + battery_width, y + health_bar_height, color
    )
  end
end
