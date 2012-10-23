require './shots/shot'

class QuickShot < Shot
  def image_offset
    1
  end
  def speed
    10
  end
  def duration
    40
  end
  def damage
    1
  end
end
