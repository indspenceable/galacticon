require './weapons/bomb_launcher'

class Ship
  attr_reader :x, :y, :hull, :player, :timers, :battery
  attr_reader :primary, :secondary, :tertiary

  attr_accessor :vel_x, :vel_y, :angle

  def initialize(window, battle, player)
    @w,@h = window.width, window.height
    @image = window.ship_images[self.class.image_offset]
    @window = window
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @hull = max_hull

    @player = player
    @timers = Hash.new(0)

    @font = window.font #Gosu::Font.new(window, "Verdana", 24)

    @tertiary = BombLauncher.new(self, battle.shots)
    @battery = max_battery
    @ticks_since_last_battery_use = 0

    @time_till_emitter = 0

  end
  def team
    player.team
  end

  def tick
    move
    @timers.each do |k,v|
      @timers[k] -= 1 if @timers[k] > 0
    end
    @ticks_since_last_battery_use += 1

    @time_till_emitter -= 1 if @time_till_emitter > 0
    battery_recovery = @ticks_since_last_battery_use - 20
    battery_recovery = 3 if battery_recovery > 5
    battery_recovery = 0 if battery_recovery < 0

    @battery += battery_recovery
    @battery = max_battery if @battery > max_battery
  end

  def color
    player.color
  end

  def damage! amt
    @hull -= amt
  end

  def warp(x, y, angle=@angle)
    @x, @y, @angle = x, y, angle
  end

  def turn_left
    @angle -= turn_speed
  end

  def turn_right
    @angle += turn_speed
  end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, acceleration)
    @vel_y += Gosu::offset_y(@angle, acceleration)
    if @time_till_emitter == 0
      @window.particles.add_emitter(TrailEmitter.new(@x,@y,2,color))
      @time_till_emitter += 5
    end
  end
  def velocity
    Math.sqrt(@vel_x*@vel_x + @vel_y*@vel_y)
  end
  def limit_velocity!
    vel = velocity
    if vel > max_velocity
      ratio = max_velocity / velocity
      @vel_x *= ratio
      @vel_y *= ratio
    end
  end
  def move
    limit_velocity!
    @x += @vel_x
    @y += @vel_y
    @x %= @w
    @y %= @h
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
    @font.draw_rel(team.to_s,@x,@y-45,1,0.5,0.5,1,1,Player::COLORS[color])
  end

  def expired?
    @hull <= 0
  end

  def max_hull
    100
  end
  def max_battery
    1000
  end
  def discharge! x
    @ticks_since_last_battery_use = 0
    @battery -= x
  end

  def explode!
    @window.particles.add_emitter(ExplosionEmitter.new(@x, @y, 100))
  end
  # DEPENDS ON:
  # image_offset
  # turn_speed
  # acceleration
end
