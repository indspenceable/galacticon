class ReverseThrusters
  def initialize ship
    @ship = ship
  end
  def activate! window
    @ship.vel_x *= -0.5
    @ship.vel_y *= -0.5
    @ship.angle +=  180
  end
end
