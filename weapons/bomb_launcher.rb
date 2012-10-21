require './weapons/simple_weapon'
require './shots/bomb'

class BombLauncher < SimpleWeapon
  def activate! window
    if @bomb && !@bomb.expired?
      @bomb.detonate!(@shots)
      @bomb = nil
    else
      @bomb = shoot!(window, Bomb)
    end
  end
  def cooldown
    25
  end
  def required_charge
    250
  end
end
