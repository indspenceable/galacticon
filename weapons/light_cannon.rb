require './weapons/simple_weapon'
require './shots/quick_shot'

class LightCannon < SimpleWeapon
  def bullet_klass
    QuickShot
  end
  def cooldown
    5
  end
end
