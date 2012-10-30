require './weapons/simple_weapon'
require './shots/gravity_well'

class GravityCannon < SimpleWeapon
  def bullet_klass
    GravityWell
  end
  def cooldown
    200
  end
  def required_charge
    300
  end
  def play_sample!(window)
    #window.sample('missile').play
  end
end
