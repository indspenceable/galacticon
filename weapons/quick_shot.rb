require './weapons/shot'

class QuickShot < Shot
  def image_offset
    14*15-2
  end
  def speed
    9
  end
  def duration
    50
  end
  def damage
    3
  end
end
