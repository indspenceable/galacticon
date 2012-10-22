require './shots/shot'

class SlowShot < Shot
  def move
    super
    #TODO this should be in a tick function
    @window.particles.add_emitter SparkEmitter.new(@x, @y, 3, @owner.color)
  end
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
