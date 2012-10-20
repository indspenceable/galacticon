require './shots/shot'

class SlowShot < Shot
  def image_offset
    14*15+2
  end
  def speed
    6
  end
  def duration
    75
  end
  def damage
    15
  end
end
