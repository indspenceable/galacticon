require './shot'

class SlowShot < Shot
  def image_offset
    14*15+2
  end
  def speed
    3
  end
end
