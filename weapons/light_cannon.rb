require './weapons/weapon'
require './shots/quick_shot'

class LightCannon < Weapon
  def activate! window
    shoot!(window, QuickShot)
  end
end
