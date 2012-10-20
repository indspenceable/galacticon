class Battle
  def initialize window, player_selections
    @window = window
  end

  #lifted from window
  def setup_ships!
    @time_between_games = TIME_BETWEEN_GAMES
    @shots = []

    @ships = []
    starting_locations = [
      [WIDTH/4 + WIDTH/4*0, HEIGHT/4 + HEIGHT/4*0],
      [WIDTH/4 + WIDTH/4*2, HEIGHT/4 + HEIGHT/4*0],
      [WIDTH/4 + WIDTH/4*0, HEIGHT/4 + HEIGHT/4*2],
      [WIDTH/4 + WIDTH/4*2, HEIGHT/4 + HEIGHT/4*2],
    ]
    @players.each do |p|
      klass = p.ship_klass || Player::SHIPS.compact.sample
      ship = klass.new(self, p)
      ship.warp(*starting_locations[p.team])
      @ships << ship
    end

    @order_of_death = []
  end

  def update
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


  def draw_player p
    total  = 100.0
    width = p.hull * (total/p.max_hull)
    height = 30

    x, y, color = case p.team
      when 0
        [0,0, Gosu::Color::RED]
      when 1
        [WIDTH - total, 0, Gosu::Color::GREEN]
      when 2
        [0, HEIGHT - height, Gosu::Color::BLUE]
      when 3
        [WIDTH - total, HEIGHT - height, Gosu::Color::FUCHSIA]
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
end
