require './weapons/simple_weapon'
require './shots/slow_shot'

class HeavyCannon < SimpleWeapon
  def bullet_klass
    SlowShot
  end
  def cooldown
    35
  end
  def required_charge
    150
  end
  def play_sample!(window)
    window.sample('missile').play
  end
end
