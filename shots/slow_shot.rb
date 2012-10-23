require './shots/shot'

class SlowShot < Shot
  def move
    super
    #TODO this should be in a tick function
    @countdown ||= 5
    @countdown -= 1
    if @countdown == 0
      @window.particles.add_emitter TrailEmitter.new(@x, @y, 1, @owner.color)
      @countdown = 2
    end
  end
  def display_emitters!
    @window.particles.add_emitter(SparkEmitter.new(@x, @y, 35, @owner.color))
  end
  def image_offset
    1
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
