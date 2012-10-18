require './weapons/weapon'
require './shots/slow_shot'

class HeavyCannon < Weapon
  def activate! window
    shoot!(window, SlowShot)
  end
end
