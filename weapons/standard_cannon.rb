require './weapons/simple_weapon'
require './shots/standard_shot'

class StandardCannon < SimpleWeapon
  def bullet_klass
    StandardShot
  end
  def cooldown
    20
  end
  def required_charge
    25
  end
end
