require './weapons/bomb_launcher'

class Ship
  attr_reader :x, :y, :angle, :hull, :team

  attr_reader :tertiary

  MAX_HULL = 100
  PLAYER_COLORS = [
    Gosu::Color::RED,
    Gosu::Color::GREEN,
    Gosu::Color::BLUE,
    Gosu::Color::FUCHSIA
  ]

  def initialize(window, team)
    @w,@h = window.width, window.height
    @image = window.ship_images[image_offset]
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    #TODO remove this.
    @shots = window.shots
    @hull = MAX_HULL

    @team = team

    @font = Gosu::Font.new(window, "Verdana", 24)

    @tertiary = BombLauncher.new(self, window.shots)
  end

  def color
    PLAYER_COLORS[@team]
  end

  def shot_offset
    16*13 + 4 + 8*team
  end

  def damage! amt
    @hull -= amt
  end

  def warp(x, y)
    @x, @y = x, y
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
  end
  def velocity
    Math.sqrt(@vel_x*@vel_x + @vel_y*@vel_y)
  end
  def limit_velocity!
    vel = velocity
    if vel > max_velocity
      # puts "Limiting Velocity... #{@vel_x} #{@vel_y}"
      ratio = max_velocity / velocity
      @vel_x *= ratio
      @vel_y *= ratio
      # puts "Limited Velocity... #{@vel_x} #{@vel_y}"
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
    @font.draw_rel(@team.to_s,@x,@y-45,1,0.5,0.5,1,1,color)
  end

  def expired?
    @hull <= 0
  end

  def shoot(window, shot, x=@x, y=@y, angle=@angle)
    shot.new(window, self).tap do |s|
      s.warp(x, y, angle)
      @shots << s
    end
  end
  def action1(window)
  end
  def action2(window)
  end
  def action3(window)

  end

  # DEPENDS ON:
  # image_offset
  # turn_speed
  # acceleration
end
