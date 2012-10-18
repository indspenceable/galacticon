require './weapons/simple_weapon'
require './shots/slow_shot'

class HeavyCannon < SimpleWeapon
  def bullet_klass
    SlowShot
  end
  def cooldown
    35
  end
end
