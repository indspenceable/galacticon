require './weapons/simple_weapon'
require './shots/bomb'

class BombLauncher < SimpleWeapon
  def activate! window
    if @bomb && !@bomb.expired?
      @bomb.detonate!(@shots)
      @bomb = nil
      window.sample("bomb_explosion").play
    else
      @bomb = shoot!(window, Bomb)
      window.sample("launch_bomb").play
    end
  end
  def cooldown
    25
  end
  def required_charge
    250
  end
end
