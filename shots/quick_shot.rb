require './shots/shot'

class QuickShot < Shot
  def image_offset
    14*15-2
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
