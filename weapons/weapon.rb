class Weapon
    def initialize ship, shots
    @ship = ship
    @shots = shots
  end
  def shoot!(window, shot, x=@ship.x, y=@ship.y, angle=@ship.angle)
    shot.new(window, @ship).tap do |s|
      s.warp(x, y, angle)
      @shots << s
    end
  end
end
