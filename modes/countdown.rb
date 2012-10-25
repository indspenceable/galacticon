class CountdownMode
  def initialize window, battle, ticks = 3
    @window = window
    @battle = battle

    @ticks = ticks
    1.upto(ticks) do |x|
      @window.delay(60*x, window, self, x==ticks) do |window, count, final|
        count.count_down!
        window.sample(final ? 'start' : 'blip').play
      end
    end
    Gosu::Song.current_song.stop if Gosu::Song.current_song
    window.sample('blip').play
  end
  def count_down!
    @ticks -= 1
  end
  def update
    @battle.start_battle! if @ticks == 0
  end
  def draw
    @battle.draw
    @window.font.draw_rel(@ticks.to_s,@window.width/2,@window.height/2,1, 0.5, 0.5, 1, 1, Gosu::Color::WHITE)
  end
  def button_down id
  end
end
