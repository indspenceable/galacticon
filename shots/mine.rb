require './shots/shot'

class Mine < Shot
  def image_offset
    0
  end
  def speed
    0
  end
  def expired?
    hit?
  end
  # def collide!(ship)

  # end

  def damage
    20
  end
end
