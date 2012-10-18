class Teleporter
  def initialize ship
    @ship = ship
  end
  def activate! window
    @ship.warp(rand(window.width), rand(window.height))
  end
end
