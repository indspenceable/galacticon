class SimpleWeapon
    def initialize ship, shots
    @ship = ship
    @shots = shots
  end
  def shoot!(window, shot, x=@ship.x, y=@ship.y, angle=@ship.angle)
    shot.new(window, @ship).tap do |s|
      s.warp(x, y, angle)
      @shots << s
    end
  end
  def attempt_activate! window
    if ready_to_shoot?
      activate!(window)
      set_timeout
    end
  end
  def activate! window
    shoot!(window, bullet_klass)
  end
  def ready_to_shoot?
    @ship.timers[timer_name] == 0
  end
  def set_timeout
    @ship.timers[timer_name] = cooldown
  end
  def timer_name
    self.class.name.to_sym
  end
end
