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
      s.check_for_collisions!(@ships)
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
    width = p.hull * (total/p.max_hull)
    height = 30

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

    #puts color.inspect, Gosu::Color::RED

    @window.draw_quad(
              x,          y, color,
      x + width,          y, color,
              x, y + height, color,
      x + width, y + height, color
    )
  end
end