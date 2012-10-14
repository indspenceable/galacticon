require './shot'

class SlowShot < Shot
  def image_offset
    14*15+2
  end
  def speed
    6
  end
  def duration
    200
  end
  def damage
    10
  end
end
