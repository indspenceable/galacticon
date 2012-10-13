require './shot'

class QuickShot < Shot
  def image_offset
    14*15+18
  end
  def speed
    7
  end
  def duration
    20
  end
end
