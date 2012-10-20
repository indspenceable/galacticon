require './weapons/simple_weapon'
require './shots/bomb'

class BombLauncher < SimpleWeapon
  def activate! window
    if @bomb
      @bomb.detonate!(@shots)
      @bomb = nil
    else
      @bomb = shoot!(window, Bomb)
    end
  end
  def cooldown
    100
  end
end
