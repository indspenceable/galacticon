require './weapons/weapon'
require './shots/bomb'

class BombLauncher < Weapon
  def activate! window
    if @bomb
      @bomb.detonate!
      @bomb = nil
    else
      @bomb = shoot!(window, Bomb)
    end
  end
end
