require './shots/shot'

class StandardShot < Shot
  def image_offset
    1
  end
  def speed
    7
  end
  def duration
    50
  end
  def damage
    3
  end
end
