require './weapons/shot'
require './weapons/shrapnel'

class Bomb < Shot
  def initialize(window, owner)
    super
  end
  def image_offset
    3
  end
  def team_offset
    2
  end
  def speed
    0.5
  end
  def expired?
    @detonated
  end
  def check_for_collisions! ships
  end
  def detonate!
    @detonated = true
    -1.upto(1) do |xo|
      -1.upto(1) do |yo|
        s = Shrapnel.new(@window, @owner)
        s.warp(x + xo*30, y + yo*30, angle)
        @window.shots << s
      end
    end
  end
end
